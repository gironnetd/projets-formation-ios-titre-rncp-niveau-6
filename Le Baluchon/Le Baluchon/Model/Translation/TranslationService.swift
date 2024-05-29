//
//  TranslateService.swift
//  Le Baluchon
//
//  Created by damien on 23/06/2022.
//

import Foundation

//
// MARK: - Translate Service
//
final class TranslationService: ApiService {
    
    static var shared: TranslationService = TranslationService()
    
    private init(){}
    
    internal var session: URLSession? = URLSession(configuration: .default)
    private var detectionSession: URLSession? = URLSession(configuration: .default)
    private var languagesSession: URLSession? = URLSession(configuration: .default)
    
    init(detectionSession: URLSession? = nil, session: URLSession? = nil, languagesSession: URLSession? = nil) {
        self.detectionSession = detectionSession
        self.session = session
        self.languagesSession = languagesSession
    }
    
    typealias DataRequest = String
    typealias CallBackResponse = (detection: String?,translation: String?)
    typealias DataResponse = TranslationResponse
    
    private lazy var q = Parameter(key: "q")
    private var target = Parameter(key : "target", value: UserDefaults.standard.string(forKey: Constants.TRANSLATION_LANGUAGE))
    private var source = Parameter(key: "source")
    private let format = Parameter(key: "format", value: "text")

    internal var httpMethod: HttpMethod { HttpMethod.post }
    internal var host: String { "translate.googleapis.com" }
    internal var endPoint: EndPoint = TranslationEndPoint.translate
    internal var path: String {
        get { "/language/translate/v2" + (endPoint as! TranslationEndPoint).rawValue }
    }
    
    internal var parameters: [Parameter] {
        switch endPoint as! TranslationEndPoint {
        case TranslationEndPoint.translate:
            return [q, target, source, format, apiKey(keyPlist: "TranslationApiKey", keyParameter: "key")]
        case TranslationEndPoint.detect:
            return [q, apiKey(keyPlist: "TranslationApiKey", keyParameter: "key")]
        case TranslationEndPoint.languages:
            return [apiKey(keyPlist: "TranslationApiKey", keyParameter: "key")]
        }
    }
    
    internal var task: URLSessionDataTask?
    
    func detectLanguage(from dataRequest: String, callBack: @escaping (String?, NetworkError?) -> Void) {
        q.value = dataRequest
        self.endPoint = TranslationEndPoint.detect
        
        task?.cancel()
        task = detectionSession?.retrieveTask(with: request, to: DataResponse.self) { data, response, error in
            DispatchQueue.main.async { [self] in
                guard let detectionResponse = data,
                      let detection = detectionResponse.data?.detections?[0]
                else {
                    callBack(nil, handleError(data: data, response: response, error: error))
                    return
                }
            
                callBack(detection[0].language, nil)
            }
        }
        task?.resume()
    }
    
    func retrieveData(from dataRequest: String, callBack: @escaping ((detection: String?, translation: String?)?, NetworkError?) -> Void) {
        
        detectLanguage(from: dataRequest, callBack: { [self] detection, error in
            guard let detection = detection, error == nil else {
                callBack((nil, nil), error)
                return
            }
            
            callBack((detection, nil), nil)
            
            source.value = detection
            target.value = UserDefaults.standard.string(forKey: Constants.TRANSLATION_LANGUAGE)
            populateParameters(dataRequest: dataRequest)
            
            self.endPoint = TranslationEndPoint.translate
            
            task?.cancel()
            task = session?.retrieveTask(with: request, to: DataResponse.self) { data, response, error in
                DispatchQueue.main.async { [self] in
                    guard let translationResponse = data,
                          let translation = translationResponse.data?.translations  else {
                        callBack((nil, nil), handleError(data: data, response: response, error: error))
                        return
                    }
                    
                    callBack((nil, translation[0].translatedText), nil)
                }
            }
            task?.resume()
        })
    }
    
    func populateParameters(dataRequest: String) {
        q.value = dataRequest
    }
    
    func retrieveLanguages(callBack: @escaping ([String]?, NetworkError?) -> Void) {
        self.endPoint = TranslationEndPoint.languages
        
        task?.cancel()
        task = languagesSession?.retrieveTask(with: request, to: DataResponse.self) { data, response, error in
            DispatchQueue.main.async { [self] in
                guard let languagesResponse = data, let languages = languagesResponse.data?.languages else {
                    callBack(nil, handleError(data: data, response: response, error: error))
                    return
                }
            
                callBack(languages.map { language in language.language}, nil)
            }
        }
        task?.resume()
    }
}

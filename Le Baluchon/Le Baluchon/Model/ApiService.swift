//
//  ApiService.swift
//  Le Baluchon
//
//  Created by damien on 25/06/2022.
//

import Foundation

//
// MARK: - Api Service
//
protocol ApiService {
    
    associatedtype DataRequest
    associatedtype CallBackResponse
    associatedtype DataResponse where DataResponse: Codable
    
    static var shared: Self { get }
    
    var parameters: [Parameter] { get }
    
    var httpMethod: HttpMethod { get }
    var host: String { get }
    var path: String { get }
    var endPoint: EndPoint { get set }
    
    var session: URLSession? { get set }
    var task: URLSessionDataTask? { get set }
    
    func populateParameters(dataRequest: DataRequest)
    
    func retrieveData(from dataRequest: DataRequest, callBack: @escaping (CallBackResponse?, NetworkError?) -> Void)
}

extension ApiService {
    
    var scheme: String { "https" }
    
    func apiKey(keyPlist: String, keyParameter: String) -> Parameter {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let apiKeys = NSDictionary(contentsOfFile:filePath!)
        let value = apiKeys?.object(forKey: keyPlist) as! String
        return Parameter(key: keyParameter, value: value, description: "")
    }
    
    var queryItems: [URLQueryItem] {
        parameters.filter { parameter in parameter.value != nil }
            .map { parameter in URLQueryItem(name: parameter.key, value: parameter.value) }
    }
    
    var request: URLRequest {
        var components: URLComponents = URLComponents()
        
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        var url = URLRequest(url: components.url!)
        url.httpMethod = httpMethod.rawValue
        return url
    }
    
//    func retrieveTask(with request: URLRequest, completionHandler: @escaping (Self.DataResponse?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//        return session.codableTask(with: request, completionHandler: completionHandler)
//    }
    
    func handleError(data: DataResponse?, response: URLResponse?, error: Error?) -> NetworkError? {
        guard let response = response as? HTTPURLResponse else {
            return NetworkError.NotImplemented
        }
        
        guard response.statusCode == 200 else  {
            return NetworkError(rawValue: (code: response.statusCode, title: nil, message: nil))
        }
        
        guard data != nil, error == nil else {
            return NetworkError.NotFound
        }
        
        return nil
    }
}

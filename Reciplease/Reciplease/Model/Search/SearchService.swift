//
//  SearchService.swift
//  Reciplease
//
//  Created by damien on 21/07/2022.
//

import Foundation
import Alamofire
import CoreData

class SearchService {
    
    static var shared: SearchService = SearchService()
    
    private init(){}
    
    var sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        return Session(configuration: configuration)
    }()
    
    public init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    private lazy var type = Parameter(key: "type", value: "public")
    private lazy var q = Parameter(key: "q")
    
    private lazy var appID: Parameter = {
        apiKey(with: "app_id")
    }()
    
    private lazy var appKey: Parameter = {
        apiKey(with: "app_key")
    }()
    
    private func apiKey(with key: String) -> Parameter {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let apiKeys = NSDictionary(contentsOfFile:filePath!)
        let value = apiKeys?.object(forKey: key) as! String
        return Parameter(key: key, value: value, description: "")
    }
    
    public func apiKeyValuesForTesting() -> [String] {
        return [appID, appKey ].reduce(into: [], { result, parameter in
            result.append("\(parameter.key)=\(parameter.value!)")
        })
    }
    
    private var parameters: [String: String] {
        return [type, q, appID, appKey].reduce(into: [:], { result, parameter in
            result[parameter.key] = parameter.value
        })
    }
    
    func retrieveRecipes(ingredients: [String], callBack: @escaping ([Recipe]?, NetworkError?) -> Void) {
        q.value = ingredients.joined(separator: ",")
        sessionManager
            .request(Constants.SEARCH_ENDPOINT, method: .get, parameters: parameters)
            .responseDecodable(of: SearchResponse.self) { response in
                switch response.result {
                case .success(let response):
                    callBack(response.hits.map { hit in hit.recipe }, nil)
                case .failure:
                    if let response = response.response {
                        callBack(nil, NetworkError(rawValue: (code: response.statusCode, title: nil, message: nil)))
                    }
                }
            }.resume()
    }
}

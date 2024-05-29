//
//  URLSession+Extension.swift
//  Le Baluchon
//
//  Created by damien on 25/06/2022.
//

import Foundation

//
// MARK: - URLSession response handlers
//
extension URLSession {
    func codableTask<T: Codable>(with request: URLRequest, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? JSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func retrieveTask<T: Codable>(with request: URLRequest,to response: T.Type, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return codableTask(with: request, completionHandler: completionHandler)
    }
}

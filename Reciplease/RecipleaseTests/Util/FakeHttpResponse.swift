//
//  FakeHttpResponse.swift
//  RecipleaseTests
//
//  Created by damien on 28/07/2022.
//

import Foundation

class FakeHttpResponse {
    
    static let OkHttpResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let FailedHttpResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 500, httpVersion: nil, headerFields: [:])!
        
    static let NotFoundResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 404, httpVersion: nil, headerFields: [:])!
        
    static let UnauthorizedResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 401, httpVersion: nil, headerFields: [:])!
       
    static let ForbiddenResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 403, httpVersion: nil, headerFields: [:])!
        
    static let BadRequestResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 400, httpVersion: nil, headerFields: [:])!
        
    static let TooManyRequestsResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 429, httpVersion: nil, headerFields: [:])!
        
    static let InternalServerErrorResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 500, httpVersion: nil, headerFields: [:])!
        
    static let BadGatewayResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 502, httpVersion: nil, headerFields: [:])!
        
    static let ServiceUnavailableResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 503, httpVersion: nil, headerFields: [:])!
    
    static let GatewayTimedOutResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 504, httpVersion: nil, headerFields: [:])!
    
    static let NotImplementedResponse = HTTPURLResponse(
       url: URL(string: "https://openclassrooms.com")!,
       statusCode: 501, httpVersion: nil, headerFields: [:])!
}


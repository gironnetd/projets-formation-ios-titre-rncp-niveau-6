//
//  NetworkError.swift
//  Reciplease
//
//  Created by damien on 28/07/2022.
//

import Foundation

//
// MARK: - Network Error
//
enum NetworkError: RawRepresentable,  Error {
    
    init?(rawValue: (code: Int,title: String?,message: String?)) {
        switch rawValue.code {
        case 404:
            self = .NotFound
        case 401:
            self = .Unauthorized
        case 403:
            self = .Forbidden
        case 400:
            self = .BadRequest
        case 429:
            self = .TooManyRequests
        case 500:
            self = .InternalServerError
        case 502:
            self = .BadGateway
        case 503:
            self = .ServiceUnavailable
        case 504:
            self = .GatewayTimedOut
        case 501:
            self = .NotImplemented
        default:
            self = .NotFound
        }
    }
    
    var rawValue: (code: Int,title: String?, message: String?) {
        switch self {
        case .NotFound:
            return (404, "Request Not Found", "The server can not find the requested resource")
        case .Unauthorized:
            return (401, "Request Unauthorized", "The client must authenticate itself to get the requested response")
        case .Forbidden:
            return (403, "Request Forbidden", "The client does not have access rights to the content")
        case .BadRequest:
            return (400, "Bad Request", "The server cannot or will not process the request due to something that is perceived to be a client error")
        case .TooManyRequests:
            return (429,
                    "Too Many Requests",
                    """
                        The user has sent too many requests in a given amount of time ("rate limiting")
                    """
                )
        case .InternalServerError:
            return (500, "InternalServerError", "The server has encountered a situation it does not know how to handle")
        case .BadGateway:
            return (502, "Bad Gateway", "This error response means that the server, while working as a gateway to get a response needed to handle the request, got an invalid response")
        case .ServiceUnavailable:
            return (503, "Service Unavailable", "The server is not ready to handle the request")
        case .GatewayTimedOut:
            return (504, "Gateway TimedOut", "This error response is given when the server is acting as a gateway and cannot get a response in time")
        case .NotImplemented:
            return (501, "Not Implemented", "The request method is not supported by the server and cannot be handled")
        }
    }
    
    typealias RawValue = (code: Int, title: String?, message: String?)
    
    //
    // MARK: - Cases
    // MARK: - Client-Side Errors
    case NotFound
    case Unauthorized
    case Forbidden
    case BadRequest
    case TooManyRequests
    
    // MARK: - Server-Side Errors
    case InternalServerError
    case BadGateway
    case ServiceUnavailable
    case GatewayTimedOut
    case NotImplemented
    
}

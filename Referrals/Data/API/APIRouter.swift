//
//  APIRouter.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    case getOpenings
    
    var path: String {
        switch self {
        case .getOpenings:
            return ""
        }
    }
    
    var parameters: [String: Any] {
        var parameters: [String: Any] = [:]
        switch self {
        case .getOpenings:
            parameters = [:]
        }
        return parameters
    }
    
    var method: HTTPMethod {
        switch self {
        case .getOpenings:
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url: URL
        switch  self {
        case .getOpenings:
            url = try APIManager.githubBaseUrl.asURL()
        default:
            url = try APIManager.linkedInBaseUrl.asURL()
        }
        var urlRequest = URLRequest(url: url)
        print(url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        return try URLEncoding.methodDependent.encode(urlRequest, with: parameters)
    }
}

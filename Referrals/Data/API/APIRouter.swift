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
    case getRecruiters
    case sendEmail
    case login(token: String)
    
    var path: String {
        switch self {
        case .getOpenings:
            return "jobs"
        case .getRecruiters:
            return "recruiters"
        case .sendEmail:
            return "refer"
        case .login:
            return "login"
        }
    }
    
    var parameters: [String: Any] {
        var parameters: [String: Any] = [:]
        switch self {
        case .getOpenings:
            parameters = [:]
        case .getRecruiters:
            parameters = [:]
        case .sendEmail:
            parameters = [:]
        case .login (let token):
            parameters = ["token_id": token]
        }
        return parameters
    }
    
    var method: HTTPMethod {
        switch self {
        case .getOpenings, .getRecruiters:
            return .get
        case .sendEmail, .login:
            return .post
            
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url: URL
        switch  self {
        case .getOpenings, .getRecruiters:
            url = try APIManager.githubBaseUrl.asURL()
        case .login:
            url = try APIManager.githubDevUrl.asURL()
        default:
            url = try APIManager.linkedInBaseUrl.asURL()
        }
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        print(urlRequest)
        urlRequest.httpMethod = method.rawValue
        return try URLEncoding.methodDependent.encode(urlRequest, with: parameters)
    }
}

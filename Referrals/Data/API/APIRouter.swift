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
    case sendEmail(strong: Bool, year: String, month: String, whereWorked: String, why: String, recruiterId: String, referred: Referred)
    case login(token: String)
    case getCompanies
    case getTokenLinkedIn
    
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
        case .getCompanies:
            return "companies"
        case .getTokenLinkedIn:
            return ""
        }
    }
    
    var parameters: [String: Any] {
        var parameters: [String: Any] = [:]
        switch self {
        case .sendEmail (let strong, let year, let month,
                         let whereWorked, let why, let recruiterId, let referred):
            parameters = [
                "strong_referral": strong,
                "year": year,
                "month": month,
                "strong_referral_where": whereWorked,
                "strong_referral_why": why,
                "recruiter_id": recruiterId,
                "job_id": referred.openingToRefer.id,
                "referred_name": referred.name,
                "referred_email": referred.email,
                "resume_file": referred.resume]
        case .login (let token):
            parameters = ["token_id": token]
        default:
            parameters = [:]
        }
        return parameters
    }
    
    var method: HTTPMethod {
        switch self {
        case .getOpenings, .getRecruiters, .getCompanies:
            return .get
        case .sendEmail, .login:
            return .post
        case .getTokenLinkedIn:
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url: URL
        switch  self {
        case .login, .getOpenings, .getRecruiters, .getCompanies, .sendEmail:
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

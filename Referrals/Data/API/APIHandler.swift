//
//  APIHandler.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import PromiseKit

struct APIHandler {
    static let sessionManager = Server.manager
    
    static func getDataFromGithub() -> Promise <[[String: Any]]> {
        return Promise { resolve in
            sessionManager.request(APIRouter.getOpenings)
                .validate()
                .responseJSON( completionHandler: { response in
                    if let json = response.result.value as? [[String: Any]] {
                        resolve.fulfill(json)
                    } else if let error = response.error {
                        resolve.reject(error)
                    }
                })
        }
    }
    
    static func getRecruiters() -> Promise <[[String: Any]]> {
        return Promise { resolve in
            sessionManager.request(APIRouter.getRecruiters)
                .validate()
                .responseJSON( completionHandler: { response in
                    if let json = response.result.value as? [[String: Any]] {
                        resolve.fulfill(json)
                    } else if let error = response.error {
                        resolve.reject(error)
                    }
                })
        }
    }
    
    static func sendEmail(strong: Bool, year: String, month: String, whereWorked: String, why: String, recruiterId: String, referred: Referred) -> Promise <[[String: Any]]> {
        return Promise { resolve in
            sessionManager.request(APIRouter.sendEmail(
                strong: strong,
                year: year,
                month: month,
                whereWorked: whereWorked,
                why: why,
                recruiterId: recruiterId,
                referred: referred))
                .validate()
                .responseJSON( completionHandler: { response in
                    if let json = response.result.value as? [[String: Any]] {
                        resolve.fulfill(json)
                    } else if let error = response.error {
                        resolve.reject(error)
                    }
                })
        }
    }
    
    static func login(token: String) -> Promise <[String: Any]> {
        return Promise { resolve in
            sessionManager.request(APIRouter.login(token: token))
            .validate()
                .responseJSON(completionHandler: { response in
                    if let json = response.result.value as? [String: Any] {
                        resolve.fulfill(json)
                    } else if let error = response.error {
                        resolve.reject(error)
                    }
                })
        }
    }
    
    static func getCompanies() -> Promise <[[String: Any]]> {
        return Promise { resolve in
            sessionManager.request(APIRouter.getCompanies)
                .validate()
                .responseJSON( completionHandler: { response in
                    if let json = response.result.value as? [[String: Any]] {
                        resolve.fulfill(json)
                    } else if let error = response.error {
                        resolve.reject(error)
                    }
                })
        }
    }
}

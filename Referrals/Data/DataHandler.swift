//
//  DataHandler.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import PromiseKit

struct DataHandler {
    
    static func getOpenings() -> Promise <[Opening]> {
        return APIHandler.getDataFromGithub().map { data -> [Opening] in
            return DataParser.parseOpenings(with: data)
        }
    }
    
    static func getRecruiters() -> Promise <[Recruiter]> {
        return APIHandler.getRecruiters().map { data -> [Recruiter] in
            return DataParser.parseRecruiters(with: data)
        }
    }
    
    static func getCompanies() -> Promise <[Company]> {
        return APIHandler.getCompanies().map { data -> [Company] in
            return DataParser.parseCompanies(with: data)
        }
    }
    
    static func login(token: String) -> Promise <[String: Any]> {
        return APIHandler.login(token: token)
    }
    
    static func logout() {
        APIHandler.logOut()
    }

    static func sendRefer(strong: Bool, year: String, month: String, whereWorked: String, why: String, recruiterId: String, referred: Referred) -> Promise <[[String: Any]]> {
        return APIHandler.sendEmail(strong: strong, year: year, month: month, whereWorked: whereWorked, why: why, recruiterId: recruiterId, referred: referred)
    }
    
    static func getReferreds() -> Promise <[Company]> {
        return APIHandler.getReferreds().map { data -> [Company] in
            return DataParser.parseCompanies(with: data)
        }
    }
}

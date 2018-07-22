//
//  DataParser.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

struct DataParser {
    static func parseOpenings(with json: [[String: Any]]) -> [Opening] {
        var openings = [Opening]()
        openings = Mapper<Opening>().mapArray(JSONArray: json)
        return openings
    }
    
    static func parseRecruiters(with json: [[String: Any]]) -> [Recruiter] {
        var recruiters = [Recruiter]()
        recruiters = Mapper<Recruiter>().mapArray(JSONArray: json)
        return recruiters
    }
    
    static func parseCompanies(with json: [[String: Any]]) -> [Company] {
        var companies = [Company]()
        companies = Mapper<Company>().mapArray(JSONArray: json)
        return companies
    }
}

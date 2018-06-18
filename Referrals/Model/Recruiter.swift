//
//  Recruiter.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/15/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

struct Recruiter: Mappable {
    var name: String
    var description: String
    var requirements: [String]
    
    init?(map: Map) {
        name = ""
        description = ""
        requirements = []
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        description <- map["description"]
        requirements <- map["requirements"]
    }
    
    
}

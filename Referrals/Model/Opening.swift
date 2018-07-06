//
//  Opening.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

struct Opening: Mappable {
    var id: Int
    var name: String
    var responsabilities: [String]
    var requirements: [String]
    var description: [String]
    var skills: [String]
    var generals: [String]
    
    init?(map: Map) {
        id = 0
        name = ""
        responsabilities = []
        requirements = []
        description = []
        skills = []
        generals = []
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["title"]
        responsabilities <- map["description.responsibilities"]
        requirements <- map["description.requirements"]
        description <- map["description.description"]
        skills <- map["description.skills"]
        generals <- map["description.generals"]
    }
}

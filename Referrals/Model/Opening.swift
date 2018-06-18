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
    var name: String
    var responsabilities: String
    var requirements: String
    var description: String
    
    init?(map: Map) {
        name = ""
        responsabilities = ""
        requirements = ""
        description = ""
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        responsabilities <- map["responsabilities"]
        requirements <- map["requirements"]
        description <- map["description"]
    }
    
}

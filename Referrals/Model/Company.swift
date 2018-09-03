//
//  Recruiter.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/15/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

struct Company: Mappable {
    var id: Int
    var name: String
    
    init?(map: Map) {
        id = 0
        name = ""
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
}

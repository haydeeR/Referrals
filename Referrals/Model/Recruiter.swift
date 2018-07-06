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
    var email: String
    var picture: String
    
    init?(map: Map) {
        name = ""
        email = ""
        picture = ""
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        picture <- map["picture"]
    }
    
    
}

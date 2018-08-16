//
//  Referred.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/29/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

class Referred: Mappable {
    var name: String
    var email: String
    var resume: String
    var openingToRefer: Opening?
    var strongRefer: StrongReferred?
    
    init(name: String, email: String, resume: String, opening: Opening, strongRefer: StrongReferred? ) {
        self.name = name
        self.email = email
        self.resume = resume
        self.openingToRefer = opening
        self.strongRefer = strongRefer
    }
    
    required init?(map: Map) {
        self.name = ""
        self.email = ""
        self.resume = ""
        self.openingToRefer = nil
        self.strongRefer = nil
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        resume <- map["resume"]
        openingToRefer <- map["opening"]
        strongRefer <- map["strongRefer"]
    }
}

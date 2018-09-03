//
//  StrongReferred.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 7/21/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation

class StrongReferred {
    var id: Int
    var userId: Int
    var year: Int
    var month: Int
    var recruiterId: Int
    var why: String
    var whereWorked: Company
    
    init(id: Int, userId: Int, year: Int, month: Int, recruiterId: Int, why: String, whereWorked: Company) {
        self.id = id
        self.userId = userId
        self.year = year
        self.month = month
        self.recruiterId = recruiterId
        self.why = why
        self.whereWorked = whereWorked
    }
}

//
//  Field.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/26/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation

struct Field {
    var fieldName: String
    var fieldDescription: String
    
    
    init (fieldName: String, fieldDescription: [String]) {
        var rows = ""
        self.fieldName = fieldName
        for row in fieldDescription {
            rows += "* " + row + "\n"
        }
        self.fieldDescription = rows
    }
}

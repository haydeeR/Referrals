//
//  ValidatorError.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 7/20/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation

struct ValidationError: Error {
    
    public let message: String
    
    public init(message m: String) {
        message = m
    }
}

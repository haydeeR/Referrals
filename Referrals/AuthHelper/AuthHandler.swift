//
//  AuthHandler.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 8/13/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import GoogleSignIn

struct AuthHandler {
    
    static func logOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    static func getCurrentAuth() {
        
    }
}

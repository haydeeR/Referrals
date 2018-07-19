//
//  Server.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import Alamofire

struct Server {
    static var manager: SessionManager {
        let oautHandler = OAuthHandler(
            accessToken: APIManager.token,
            baseURLString: APIManager.githubDevUrl
        )
        let sessionManager = SessionManager()
        sessionManager.adapter = oautHandler
        return sessionManager
    }
    
}

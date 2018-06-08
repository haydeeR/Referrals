//
//  APIHandler.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import PromiseKit

struct APIHandler {
    static let sessionManager = Server.manager
    
    static func getDataFromGithub() -> Promise <String> {
        return Promise { resolve in
            sessionManager.request(APIRouter.getOpenings)
                .validate()
                .responseString( completionHandler: { response in
                    if let json = response.result.value {
                        resolve.fulfill(json)
                    } else if let error = response.error {
                        resolve.reject(error)
                    }
                })
        }
    }
}

//
//  DataHandler.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import PromiseKit

struct DataHandler {
    
    static func getOpenings() -> Promise <[Opening]> {
        return APIHandler.getDataFromGithub().map { data -> [Opening] in
            return DataParser.parseOpenings(with: data)
        }
    }
}

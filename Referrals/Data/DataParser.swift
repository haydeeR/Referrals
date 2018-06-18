//
//  DataParser.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

struct DataParser {
    static func parseOpenings(with json: [[String: Any]]) -> [Opening] {
        var openings = [Opening]()
        openings = Mapper<Opening>().mapArray(JSONArray: json)
        return openings
    }
}

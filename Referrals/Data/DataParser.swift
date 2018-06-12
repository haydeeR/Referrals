//
//  DataParser.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation

struct DataParser {
    static let numberOfSection = 2
    
    static func parseOpenings(with data: String) -> [Opening] {
        let openings: [Opening] = []
        var sections = data.components(separatedBy: "<!-- yaspeller ignore:end -->")
        sections = sections[0].components(separatedBy: "<!-- yaspeller ignore:start -->")
        sections = sections[1].components(separatedBy: "* [")
        for item in 0..<sections.count {
            print("item \(item): \(sections[item])")
        }
        return openings

    }
}

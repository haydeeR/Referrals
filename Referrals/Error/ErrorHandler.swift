//
//  ErrorHandler.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 7/12/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import NotificationBannerSwift

struct ErrorHandler {
    
    static func handle(spellError error: ErrorType) {
        switch error {
        case .connectivity:
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "Network", subtitle: "You have a problem with your conectivity", style: .danger)
                banner.show()
            }
        case .notFound:
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "Not found", subtitle: "You have a problem with your conectivity", style: .danger)
                banner.show()
            }
        default:
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "Error", subtitle: "An error occurred", style: .danger)
                banner.show()
            }
        }
    }
}

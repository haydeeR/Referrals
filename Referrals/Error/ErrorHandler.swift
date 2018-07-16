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
    
    static func handle(spellError error: NSError) {
        switch error.code {
        case NSURLErrorTimedOut:
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "TimeOut", subtitle: "The resources you request are no longer available. \n This is normally caused by timeout", style: .danger)
                banner.show()
            }
        case NSURLErrorNotConnectedToInternet:
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "Network", subtitle: "You have a problem with your conectivity", style: .danger)
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

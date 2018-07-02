//
//  UITableViewCell+ReusableIdentifier.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/26/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reusableID: String {
        return String(describing: self)
    }
}

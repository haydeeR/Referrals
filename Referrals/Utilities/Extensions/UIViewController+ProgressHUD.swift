//
//  UIViewController+ProgressHUD.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 7/12/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import SVProgressHUD

extension UIViewController {
    func toogleHUD(show: Bool) {
        switch show {
        case true:
            //      SVProgressHUD.setForegroundColor(.white)
            //      SVProgressHUD.setBackgroundLayerColor(.white)
            SVProgressHUD.show()
        case false:
            SVProgressHUD.dismiss()
        }
    }
}

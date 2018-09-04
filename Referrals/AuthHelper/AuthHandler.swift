//
//  AuthHandler.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 8/13/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import GoogleSignIn
import UIKit

struct AuthHandler {
    
    static func logOut(logoutVC: ProfileViewController) {
        let alert = UIAlertController(title: "Saying goodbye?", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let calcelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            return
        }
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            DataHandler.logout()
            GIDSignIn.sharedInstance().signOut()
            logoutVC.changeView(with: StoryboardPath.login.rawValue, viewControllerName: ViewControllerPath.loginViewController.rawValue)
            }
        alert.addAction(calcelAction)
        alert.addAction(logoutAction)
        logoutVC.present(alert, animated: true, completion: nil)

    }
}

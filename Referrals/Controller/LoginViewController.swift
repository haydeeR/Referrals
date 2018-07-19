//
//  LoginViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var referralsTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        referralsTitle.text = NSLocalizedString("Referrals", comment: "")
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
    }
    
  
    
}


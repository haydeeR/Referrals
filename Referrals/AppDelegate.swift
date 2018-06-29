//
//  AppDelegate.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GIDSignIn.sharedInstance().clientID = "77774559179-3cv4ibai8j5jadt8sg9c08pvfq994hvu.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        verifyAuth()
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])-> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
        
    }
    
    
    

}

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            initView(with: StoryboardPath.login.rawValue, viewControllerName: ViewControllerPath.loginViewController.rawValue)
        } else {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("""
                userId = \(String(describing: userId))
                idToken = \(String(describing: idToken))
                fullname = \(String(describing: fullName))
                givenName = \(String(describing: givenName))
                familyName = \(String(describing: familyName))
                email = \(String(describing: email))
            """)
            initView(with: StoryboardPath.main.rawValue, viewControllerName: ViewControllerPath.navigationOpenings.rawValue)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}

extension AppDelegate {
   
    func verifyAuth() {
        var storyboard: String
        var initialViewController: String
        
        if GIDSignIn.sharedInstance().currentUser != nil {
            storyboard =  StoryboardPath.main.rawValue
            initialViewController = ViewControllerPath.navigationOpenings.rawValue
        } else {
            storyboard =  StoryboardPath.login.rawValue
            initialViewController = ViewControllerPath.loginViewController.rawValue
        }
        initView(with: storyboard, viewControllerName: initialViewController)
    }
    
    func initView(with storyboardName: String, viewControllerName: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as UIViewController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
}

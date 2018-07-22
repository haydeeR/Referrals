//
//  AppDelegate.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import GoogleSignIn
import PromiseKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GIDSignIn.sharedInstance().clientID = "619285192685-dubas0eo9nf37c5it81fi72f8ghkgr30.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().hostedDomain = "nearsoft.com"
        GIDSignIn.sharedInstance().delegate = self
  //      GIDSignIn.sharedInstance().signOut()
        Fabric.with([Crashlytics.self])
        verifyAuth()
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
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
        if let user = user,
            user.hostedDomain != signIn.hostedDomain {
            ErrorHandler.handle(spellError: NSError(domain: "LOGIN", code: 001, userInfo: ["Account": "Your hosted domaini has to be nearsoft.com"]) )
            signIn.disconnect()
            return
        }
        if let error = error {
            print("\(error.localizedDescription)")
            initView(with: StoryboardPath.login.rawValue, viewControllerName: ViewControllerPath.loginViewController.rawValue)
        } else {
            if let idToken = user.authentication.idToken {
                print(idToken)
                firstly {
                    DataHandler.login(token: idToken)
                    }.done { result in
                        print(result)
                        self.initView(with: StoryboardPath.main.rawValue, viewControllerName: ViewControllerPath.navigationOpenings.rawValue)
                    }.catch { error in
                        print(error.localizedDescription)
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        }
        let storyboard =  StoryboardPath.login.rawValue
        let initialViewController = ViewControllerPath.loginViewController.rawValue
        initView(with: storyboard, viewControllerName: initialViewController)
    }
}

extension AppDelegate {
   
    func verifyAuth() {
        var storyboard: String
        var initialViewController: String
        
        GIDSignIn.sharedInstance().signInSilently()
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

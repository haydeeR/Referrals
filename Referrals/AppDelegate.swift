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
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications()
        GIDSignIn.sharedInstance().clientID = APIManager.googleClientId
        GIDSignIn.sharedInstance().hostedDomain = "nearsoft.com"
        GIDSignIn.sharedInstance().delegate = self
        //GIDSignIn.sharedInstance().signOut()
        Fabric.with([Crashlytics.self])
        application.applicationIconBadgeNumber = 0
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let badgeCount = application.applicationIconBadgeNumber
        application.applicationIconBadgeNumber = badgeCount + 1
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let badgecount = UIApplication.shared.applicationIconBadgeNumber
        UIApplication.shared.applicationIconBadgeNumber = badgecount + 1
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
                        self.initView(with: StoryboardPath.newDesign.rawValue, viewControllerName: ViewControllerPath.tabBarOpenings.rawValue)
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
            storyboard =  StoryboardPath.newDesign.rawValue
            initialViewController = ViewControllerPath.tabBarOpenings.rawValue
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

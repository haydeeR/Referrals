//
//  PositionDetailViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/18/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit

class PositionDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typeOfViewSegment: UISegmentedControl!
    @IBOutlet weak var linkedInContainer: UIView!
    var opening: Opening?
    var accessToken: LISDKAccessToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAccount(then: {
            print("hello")
        }, or: { (error) in
            print(error)
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAccount(then: (() -> Void)?, or: ((String) -> Void)?) { // then & or are handling closures
        if let token = accessToken {
            LISDKSessionManager.createSession(with: token)
            if LISDKSessionManager.hasValidSession() {
                LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,headline,location,industry,current-share,num-connections,num-connections-capped,summary,specialties,positions,picture-url,picture-urls::(original))?format=json",
                                                           success: {
                                                            response in
                                                            print(response?.data ?? "response")
                                                            then?()
                },
                                                           error: {
                                                            error in
                                                            print(error ?? "error")
                }
                )
            }
        } else {
            LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true,
                                              successBlock: {
                                                (state) in
                                                self.accessToken = LISDKSessionManager.sharedInstance().session.accessToken
                                                if LISDKSessionManager.hasValidSession() {
                                                    LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,headline,location,industry,current-share,num-connections,num-connections-capped,summary,specialties,positions,picture-url,picture-urls::(original))?format=json",
                                                                                               success: {
                                                                                                response in
                                                                                                print(response?.data ?? "response")
                                                                                                then?()
                                                    },
                                                                                               error: {
                                                                                                error in
                                                                                                print(error ?? "error")
                                                    }
                                                    )
                                                }
            },
                                              errorBlock: {
                                                (error) in
                                                print(error.debugDescription)
            }
            )
        }
    }

}

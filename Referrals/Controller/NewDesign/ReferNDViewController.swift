//
//  ReferNDViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 8/13/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import SearchTextField
import PromiseKit

class ReferNDViewController: UIViewController {

    @IBOutlet weak var recruiterLabel: SearchTextField!
    
    var accessToken: LISDKAccessToken?
    var recruitersName: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        recruiterLabel.delegate = self
        setUpRecruiterField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func referLinkedin() {
        // MARK: - Linked-In
        loadAccount(then: {
            print("hello")
        }, or: { (error) in
            print(error)
        })
    }
    
    private func setUpRecruiterField() {
        recruiterLabel.startVisibleWithoutInteraction = false
        getRecruiters()
    }
    
    private func getRecruiters() {
        firstly {
            DataHandler.getRecruiters()
            }.done { recruiters in
                self.recruitersName = recruiters.map({ (recruiter) -> String in
                    return recruiter.name
                })
                self.recruiterLabel.filterStrings(self.recruitersName)
            }.catch { error in
                print(error.localizedDescription)
                ErrorHandler.handle(spellError: error as NSError)
        }
    }

    func loadAccount(then: (() -> Void)?, or: ((String) -> Void)?) { // then & or are handling closures
        if let token = accessToken {
            LISDKSessionManager.createSession(with: token)
            if LISDKSessionManager.hasValidSession() {
                LISDKAPIHelper.sharedInstance().getRequest(
                    "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,headline,location,industry,current-share,num-connections,num-connections-capped,summary,specialties,positions,picture-url,picture-urls::(original))?format=json",
                    success: { response in
                        print(response?.data ?? "response")
                        then?()
                },
                    error: { error in
                        print(error ?? "error")
                }
                )
            }
        } else {
            LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (_) in
                self.accessToken = LISDKSessionManager.sharedInstance().session.accessToken
                if LISDKSessionManager.hasValidSession() {
                    LISDKAPIHelper.sharedInstance().getRequest(
                        "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,headline,location,industry,current-share,num-connections,num-connections-capped,summary,specialties,positions,picture-url,picture-urls::(original))?format=json",
                        success: { response in
                            print(response?.data ?? "response")
                            then?()
                    },
                        error: { error in
                            print(error ?? "error")
                    }
                    )
                }
            },
                errorBlock: { (error) in
                    print(error.debugDescription)
            }
            )
        }
    }

}

extension ReferNDViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       if textField == recruiterLabel {
            recruiterLabel.startVisible = true
        }
        return true
    }
    
}

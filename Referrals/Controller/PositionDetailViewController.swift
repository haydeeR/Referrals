//
//  PositionDetailViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/18/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit

class PositionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typeOfViewSegment: UISegmentedControl!
    @IBOutlet weak var linkedInContainer: UIView!
    var opening: Opening?
    var accessToken: LISDKAccessToken?
    var fields: [Field] = []
    fileprivate var contactViewController: ContactViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let contactController = childViewControllers.first as? ContactViewController else  {
            fatalError("Check storyboard for missing contactController")
        }
        contactViewController = contactController
        contactController.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        registerCells()
        setUpView()
        splitRequirements()
        //loadAccount(then: {
        //    print("hello")
        //}, or: { (error) in
        //    print(error)
        //})
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setUpView() {
        typeOfViewSegment.selectedSegmentIndex = 1
        navigationItem.title = "Opening"
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func registerCells() {
        let nib = UINib(nibName: PositionTableViewCell.reusableID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PositionTableViewCell.reusableID)
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
            LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PositionTableViewCell.reusableID, for: indexPath) as! PositionTableViewCell
        cell.config(with: fields[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}


extension PositionDetailViewController{
    
    func choseRecruiter(name: String, email: String) {
        guard let opening = opening else {
            return
        }
        let referred = Referred(name: name, email: email, resume: "No", openingToRefer: opening)
        performSegue(withIdentifier: SegueIdentifier.referSegue.rawValue, sender: referred)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifierString = segue.identifier, let identifier = SegueIdentifier(rawValue: identifierString) else {
            return
        }
        if identifier == SegueIdentifier.referSegue {
            guard let controller = segue.destination as? ReferViewController else {
                return
            }
            guard let referred = sender as? Referred else {
                return
            }
            controller.referred = referred
        }
    }
    
    func splitRequirements()
    {
        guard let opening = opening else {
            return
        }
        if  opening.requirements.count > 0 {
            let field = Field(fieldName: "Requirements", fieldDescription: opening.requirements)
            fields.append(field)
        }
        if  opening.responsabilities.count > 0 {
            let field = Field(fieldName: "Responsibilities", fieldDescription: opening.responsabilities)
            fields.append(field)
        }
        if  opening.skills.count > 0 {
            let field = Field(fieldName: "Skills", fieldDescription: opening.skills)
            fields.append(field)
        }
        if  opening.generals.count > 0 {
            let field = Field(fieldName: "Generals", fieldDescription: opening.generals)
            fields.append(field)
        }
    }
}

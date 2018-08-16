//
//  ProfileTableViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 8/3/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pushLogout() {
        AuthHandler.logOut()
    }
}

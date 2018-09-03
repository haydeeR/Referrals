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
        // self.clearsSelectionOnViewWillAppear = false
        navigationItem.title = "Profile"
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }

    @IBAction func pushLogout() {
        AuthHandler.logOut(logoutVC: self)
    }
    
    func changeView(with storyboardName: String, viewControllerName: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as UIViewController
        present(initialViewController, animated: true, completion: nil)
    }
}

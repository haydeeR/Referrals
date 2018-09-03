//
//  ProfileTableViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 8/3/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
       }
    
    private func setupView() {
        navigationItem.title = NSLocalizedString("Profile", comment: "")
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = 2
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
}

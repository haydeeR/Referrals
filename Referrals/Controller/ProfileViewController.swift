//
//  ProfileTableViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 8/3/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import PromiseKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var referred: [Referred] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerNibs()
        getReferrals()
    }
    
    private func setupView() {
        navigationItem.title = NSLocalizedString("Profile", comment: "")
        tableview.dataSource = self
        tableview.delegate = self
        tableview.tableFooterView = UIView(frame: .zero)
    }

    private func registerNibs() {
        var nib = UINib(nibName: ProfileTableViewCell.reusableID, bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: ProfileTableViewCell.reusableID)
        nib = UINib(nibName: ReferedTableViewCell.reusableID, bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: ReferedTableViewCell.reusableID)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = 2
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return referred.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reusableID, for: indexPath)
        return cell
    }
    
}

extension ProfileViewController {
    
    func getReferrals() {
//        toogleHUD(show: true)
//        firstly {
//            DataHandler.getReferreds()
//            }.done {
//                self.toogleHUD(show: false)
//            }.catch { error in
//                self.toogleHUD(show: false)
//                ErrorHandler.handle(spellError: error as NSError)
//        }
    }
}

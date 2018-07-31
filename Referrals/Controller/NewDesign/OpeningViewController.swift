//
//  OpeningViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 7/27/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import PromiseKit

class OpeningViewController: UIViewController {

    var openings: [Opening] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getOpenings()
        
    }

    func setUpView() {
        navigationItem.title = NSLocalizedString("Our openings", comment: "")
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func getOpenings() {
        toogleHUD(show: true)
        firstly {
            DataHandler.getOpenings()
            }.done { openings in
                self.openings = openings
                self.tableView.reloadData()
                self.toogleHUD(show: false)
            }.catch { error in
                self.toogleHUD(show: false)
                ErrorHandler.handle(spellError: error as NSError)
        }
    }
    
}

extension OpeningViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: ReusableIdentifier.positionIdentifier.rawValue)
        cell.textLabel?.text = openings[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let opening = openings[indexPath.row]
        performSegue(withIdentifier: SegueIdentifier.openingDetail.rawValue, sender: opening)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

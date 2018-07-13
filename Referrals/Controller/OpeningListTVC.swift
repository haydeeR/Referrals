//
//  ViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import PromiseKit
import FacebookShare
import Social

class OpeningListTVC: UITableViewController {

    var openings: [Opening] = []
    
    override func viewDidLoad() {
        setUpView()
        getOpenings()
    }
    
    func setUpView() {
        navigationItem.title = "Our openings"
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
            print(error.localizedDescription)
            ErrorHandler.handle(spellError: ErrorType.connectivity)
        }
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: ReusableIdentifier.positionIdentifier.rawValue)
        cell.textLabel?.text = openings[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let opening = openings[indexPath.row]
        performSegue(withIdentifier: SegueIdentifier.detailPosition.rawValue, sender: opening)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareFacebook  = UITableViewRowAction(style: .normal, title: "Facebook") { action, indexPath in
            self.shareOnFacebook(indexPath: indexPath)
        }
        let shareTwitter = UITableViewRowAction(style: .normal, title: "Twitter") { (action, indexPath) in
            self.shareOnTwitter(indexPath: indexPath)
        }
        shareFacebook.backgroundColor = .blue
        shareTwitter.backgroundColor = .cyan
        
        return [shareFacebook,shareTwitter]
    }
    
    func shareOnTwitter(indexPath: IndexPath) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc?.add(URL(string: "https://github.com/Nearsoft/jobs/blob/master/readme.md"))
        vc?.setInitialText("Hey look out all positions")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func shareOnFacebook(indexPath: IndexPath) {
        let content = LinkShareContent(url: URL(string: "https://github.com/Nearsoft/jobs/blob/master/readme.md")!)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            // Handle share results
        }
        do {
            try shareDialog.show()
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       guard let identifierString = segue.identifier, let identifier = SegueIdentifier(rawValue: identifierString) else {
            return
        }
        if identifier == SegueIdentifier.detailPosition {
            guard let controller = segue.destination as? PositionDetailViewController else {
                return
            }
            guard let opening = sender as? Opening else {
                return
            }
            controller.opening = opening
        }
    }
    
}


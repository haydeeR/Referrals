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
    var searchActive: Bool = false
    var filtered: [String] = []
    var data: [String] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        setUpView()
        getOpenings()
        
    }

    func setUpView() {
        navigationItem.title = NSLocalizedString("Openings", comment: "")
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func getOpenings() {
        toogleHUD(show: true)
        firstly {
            DataHandler.getOpenings()
            }.done { openings in
                self.openings = openings
                self.data = openings.map({ opening in
                    return opening.name
                })
                self.tableView.reloadData()
                self.toogleHUD(show: false)
            }.catch { error in
                self.toogleHUD(show: false)
                ErrorHandler.handle(spellError: error as NSError)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifierString = segue.identifier, let identifier = SegueIdentifier(rawValue: identifierString) else {
            return
        }
        if identifier == SegueIdentifier.openingNewDetail {
            guard let controller = segue.destination as? DetailViewController else {
                return
            }
            guard let opening = sender as? Opening else {
                return
            }
            controller.opening = opening
        }
    }
    
}

extension OpeningViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        return openings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: ReusableIdentifier.positionIdentifier.rawValue)
        if searchActive {
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = openings[indexPath.row].name
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let opening = openings[indexPath.row]
        performSegue(withIdentifier: SegueIdentifier.openingNewDetail.rawValue, sender: opening)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension OpeningViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if filtered.isEmpty {
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
}

//
//  PositionDetailViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/18/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit

class OpeningDetailsVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typeOfViewSegment: UISegmentedControl!
    @IBOutlet weak var linkedInContainer: UIView!
   
    var opening: Opening?
    var accessToken: LISDKAccessToken?
    var fields: [Field] = []
    fileprivate var contactViewController: ContactViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        registerNib()
        splitRequirements()
        guard let contactController = childViewControllers.first as? ContactViewController else {
            fatalError("Check storyboard for missing contactController")
        }
        contactViewController = contactController
        contactController.delegate = self
    }
    
    func setUpView() {
        navigationItem.title = NSLocalizedString("Opening", comment: "")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
    }
    
    func registerNib() {
        let nib = UINib(nibName: PositionTableViewCell.reusableID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PositionTableViewCell.reusableID)
    }
    
    
    
    func choseRecruiter(name: String, email: String) {
        guard let opening = opening else {
            return
        }
        let referred = Referred(name: name, email: email, resume: "no", opening: opening, strongRefer: nil)
        performSegue(withIdentifier: SegueIdentifier.referSomeone.rawValue, sender: referred)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifierString = segue.identifier, let identifier = SegueIdentifier(rawValue: identifierString) else {
            return
        }
        if identifier == SegueIdentifier.referSomeone {
            guard let controller = segue.destination as? ReferViewController else {
                return
            }
            guard let referred = sender as? Referred else {
                return
            }
            controller.referred = referred
        }
    }
    
    func splitRequirements() {
        guard let opening = opening else {
            return
        }
        if  opening.requirements.isEmpty == false {
            let field = Field(fieldName: "Requirements", fieldDescription: opening.requirements)
            fields.append(field)
        }
        if  opening.responsabilities.isEmpty == false {
            let field = Field(fieldName: "Responsibilities", fieldDescription: opening.responsabilities)
            fields.append(field)
        }
        if  opening.skills.isEmpty == false {
            let field = Field(fieldName: "Skills", fieldDescription: opening.skills)
            fields.append(field)
        }
        if  opening.generals.isEmpty == false {
            let field = Field(fieldName: "Generals", fieldDescription: opening.generals)
            fields.append(field)
        }
        tableView.reloadData()
    }

}

extension OpeningDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: PositionTableViewCell.reusableID, for: indexPath) as? PositionTableViewCell)!
        cell.config(with: fields[indexPath.row])
        return cell
    }
}

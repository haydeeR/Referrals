//
//  ReferViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/22/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit

class ReferViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchTypeReferral: UISwitch!
    @IBOutlet weak var stackStrongReferral: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeViewAction(_ sender: UISwitch) {
    }
    
}

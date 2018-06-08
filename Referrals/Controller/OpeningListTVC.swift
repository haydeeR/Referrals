//
//  ViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import PromiseKit

class OpeningListTVC: UITableViewController {

    override func viewDidLoad() {
        getOpenings()
    }
    
    func getOpenings() {
        firstly {
           DataHandler.getOpenings()
        }.done { foo in
            print(foo)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
  
}


//
//  DetailViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 8/3/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var referred: Referred?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pushLogout() {
        AuthHandler.logOut()
    }
    
    @IBAction func sendReferral() {
        performSegue(withIdentifier: SegueIdentifier.detailtoCreateRefer.rawValue, sender: nil)
    }
    
    @IBAction func shareByWhatsapp() {
        
    }
    
    @IBAction func shareByLinkedin() {
        
    }
    
    @IBAction func shareByGmail() {
        
    }
    
    @IBAction func shareByTwitter() {
        
    }
    
    @IBAction func shareByFacebook() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

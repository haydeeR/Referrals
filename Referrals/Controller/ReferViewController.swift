//
//  ReferViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/22/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import PromiseKit
import MessageUI

class ReferViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchTypeReferral: UISwitch!
    @IBOutlet weak var stackStrongReferral: UIStackView!
    @IBOutlet weak var whenLabel: UITextField!
    @IBOutlet weak var whereLabel: UITextField!
    @IBOutlet weak var whyLabel: UITextField!
    
    var referred: Referred?
    var recruiters: [Recruiter] = []
    var recruiter: Recruiter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUpView()
        getRecruiters()
    }

    func getRecruiters() {
        firstly {
            DataHandler.getRecruiters()
            }.done { recruiters in
                self.recruiters = recruiters
                self.tableView.reloadData()
            }.catch { error in
                print(error.localizedDescription)
        }
    }
    
    func setUpView() {
        switchTypeReferral.setOn(true, animated: true)
        navigationItem.title = "Recruiters"
        let btn = UIBarButtonItem(title: "Enviar", style: .done, target: self, action: #selector(doneRefer))
        var btns: [UIBarButtonItem] = []
        btns.append(btn)
        navigationItem.setRightBarButtonItems(btns, animated: true)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @objc func doneRefer() {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure to refer?", preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionOk = UIAlertAction(title: "Refer", style: .default) { (action) in
            self.sendEmail()
        }
        alert.addAction(actionCancel)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([(recruiter?.email)!])
        mailComposerVC.setSubject("You have a new refer")
        let message = """
        Refer name: \(String(describing: referred?.name))
        Refer email \(String(describing: referred?.email))
        He/She has work at \(whereLabel.text!)
        He/She worked \(whenLabel!)
        He/She has referred because: \(whyLabel.text!)
        """
        mailComposerVC.setMessageBody(message, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Something wrong", message: "We will send an email with the referred later", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(action)
        present(sendMailErrorAlert,animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeViewAction(_ sender: UISwitch) {
        stackStrongReferral.isHidden = !stackStrongReferral.isHidden
    }
    
}

extension ReferViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = recruiters.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: ReusableIdentifier.recruiterIdentifier.rawValue)
        cell.textLabel?.text = recruiters[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         recruiter = recruiters[indexPath.row]
    }
}

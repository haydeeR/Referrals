//
//  ContactViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/22/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import Validator

class ContactViewController: UIViewController {

    @IBOutlet weak var nameRefer: UITextField!
    @IBOutlet weak var emailRefer: UITextField!
    @IBOutlet weak var resumeBtn: UIButton!
    @IBOutlet weak var statusName: UILabel!
    @IBOutlet weak var statusemail: UILabel!
    
    var nameRuleSet: ValidationRuleSet<String>? {
        didSet { nameRefer.validationRules = nameRuleSet }
    }
    var emailRuleSet: ValidationRuleSet<String>? {
        didSet { nameRefer.validationRules = emailRuleSet }
    }
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    var keyboardAppearObserver: NotificationCenter?
    var keyboardDisappearObserver: NotificationCenter?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func addValidationsForFields() {
        nameRuleSet = ValidationRuleSet<String>()
        emailRuleSet = ValidationRuleSet<String>()
    
        let minLengthRule = ValidationRuleLength(min: 5, error: ValidationError(message: "😫"))
        nameRuleSet?.add(rule: minLengthRule)
        let emailPattern = EmailValidationPattern.simple
        let emailRule = ValidationRulePattern(pattern: emailPattern, error: ValidationError(message: "😫"))
        emailRuleSet?.add(rule: emailRule)
        
        nameRefer.validationRules = nameRuleSet
        nameRefer.validateOnInputChange(enabled: true)
        nameRefer.validationHandler = { result in self.updateValidationNameState(result: result) }
        
        emailRefer.validationRules = emailRuleSet
        emailRefer.validateOnInputChange(enabled: true)
        emailRefer.validationHandler = { result in self.updateValidationEmailState(result: result) }
    }
    
    private func updateValidationNameState(result: ValidationResult) {
        switch result {
        case .valid:
            statusName.text = "😀"
        case .invalid(let failures):
            let messages = failures.compactMap { $0 as? ValidationError }.map { $0.message }
            statusName.text = messages.joined(separator: "")
        }
    }
    
    private func updateValidationEmailState(result: ValidationResult) {
        switch result {
        case .valid:
            statusemail.text = "😀"
        case .invalid(let failures):
            let messages = failures.compactMap { $0 as? ValidationError }.map { $0.message }
            statusemail.text = messages.joined(separator: "")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        keyboardDisappearObserver?.removeObserver(self)
        keyboardAppearObserver?.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keyboardAppearObserver?.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        keyboardDisappearObserver?.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
    }
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        activeField?.resignFirstResponder()
        activeField = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let activeFiedl = activeField {
            activeFiedl.resignFirstResponder()
        }
    }

    @IBAction func sendReferAction(_ sender: UIButton) {
        if let activeField = activeField {
            activeField.resignFirstResponder()
        }
        if let name = statusName?.text,
            let email = statusemail?.text,
            name == "😀", email == "😀"{
        } else {
            let alert = UIAlertController(title: "Ups", message: "Remember fill out all required fields 😩", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
      
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      
    }
    
    @IBAction func addResumeAction(_ sender: UIButton) {
       
    }
}

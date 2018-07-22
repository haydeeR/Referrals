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
    weak var delegate: OpeningDetailsVC?
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    var keyboardAppearObserver: NotificationCenter?
    var keyboardDisappearObserver: NotificationCenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameRefer.delegate = self
        emailRefer.delegate = self
        addValidationsForFields()
        // Observe keyboard change
        keyboardAppearObserver = NotificationCenter.default
        keyboardDisappearObserver = NotificationCenter.default
        
        // Add touch gesture for contentView
        self.delegate?.linkedInContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
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
            delegate?.choseRecruiter(name: name, email: email)
        } else {
            let alert = UIAlertController(title: "Ups", message: "Remember fill out all required fields 😩", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.delegate?.bottomConstraint.constant += self.keyboardHeight
            })
            // move if keyboard hide input field
            let distanceToBottom = (self.delegate?.scrollView.frame.size.height)! - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            if collapseSpace < 0 {
                // no collapse
                return
            }
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.delegate?.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardHeight = keyboardHeight {
        UIView.animate(withDuration: 0.3) {
            self.delegate?.bottomConstraint.constant -= keyboardHeight
            self.delegate?.scrollView.contentOffset = self.lastOffset
            }
        }
        keyboardHeight = nil
    }
    
    @IBAction func addResumeAction(_ sender: UIButton) {
       
    }
}

extension ContactViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = delegate?.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}

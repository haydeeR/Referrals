//
//  ReferViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/22/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import PromiseKit
import Validator
import SearchTextField

class ReferViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchTypeReferral: UISwitch!
    @IBOutlet weak var stackStrongReferral: UIStackView!
    @IBOutlet weak var whenLabel: UITextField!
    @IBOutlet weak var whereLabel: SearchTextField!
    @IBOutlet weak var whyLabel: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var whenStatusLabel: UILabel!
    @IBOutlet weak var whereStatusLabel: UILabel!
    @IBOutlet weak var whyStatusLabel: UILabel!
    
    var referred: Referred?
    var recruiters: [Recruiter] = []
    var companies: [String] = []
    var recruiter: Recruiter?
    var activeField: UITextField?
    var oldActiveField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    var keyboardAppearObserver: NotificationCenter?
    var keyboardDisappearObserver: NotificationCenter?
    let expiryDatePicker = MonthYearPickerView()
    var whenRuleSet: ValidationRuleSet<String>? {
        didSet { whenLabel.validationRules = whenRuleSet}
    }
    var whereRuleSet: ValidationRuleSet<String>? {
        didSet { whereLabel.validationRules = whereRuleSet}
    }
    var whyRuleSet: ValidationRuleSet<String>? {
        didSet { whyLabel.validationRules = whyRuleSet }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        whenLabel.delegate = self
        whereLabel.delegate = self
        whyLabel.delegate = self
        
        // Observe keyboard change
        keyboardAppearObserver = NotificationCenter.default
        keyboardDisappearObserver = NotificationCenter.default
        
        // Add touch gesture for contentView
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        
        setUpView()
        setUpWhereField()
        addValidationsForFields()
        setUpToolBarDate()
        registerNibs()
        getRecruiters()
       
    }
    
    private func setUpWhereField() {
        whereLabel.startVisibleWithoutInteraction = false
        // Set data source
        getCompanies()
        
    }

    fileprivate func getCompanies() {
        firstly {
            DataHandler.getCompanies()
            }.done { companies in
                self.companies = companies.map({ (company) -> String in
                    return company.name
                })
                self.whereLabel.filterStrings(self.companies)
            }.catch { error in
                print(error.localizedDescription)
                ErrorHandler.handle(spellError: error as NSError)
        }
    }

    private func addValidationsForFields() {
        whereRuleSet = ValidationRuleSet<String>()
        whenRuleSet = ValidationRuleSet<String>()
        whyRuleSet = ValidationRuleSet<String>()
        
        let minLengthRule = ValidationRuleLength(min: 3, error: ValidationError(message: "😫"))
        whenRuleSet?.add(rule: minLengthRule)
        whereRuleSet?.add(rule: minLengthRule)
        whyRuleSet?.add(rule: minLengthRule)
        
        whenLabel.validationRules = whenRuleSet
        whenLabel.validateOnEditingEnd(enabled: true)
        whenLabel.validationHandler = { result in self.updateValidationWhenState(result: result) }
        
        whereLabel.validationRules = whereRuleSet
        whereLabel.validateOnInputChange(enabled: true)
        whereLabel.validationHandler = { result in self.updateValidationWhereState(result: result) }
        
        whyLabel.validationRules = whyRuleSet
        whyLabel.validateOnInputChange(enabled: true)
        whyLabel.validationHandler = { result in self.updateValidationWhyState(result: result) }
    }
    
    private func updateValidationWhenState(result: ValidationResult) {
        switch result {
        case .valid:
            whenStatusLabel.text = "😀"
        case .invalid(let failures):
            let messages = failures.compactMap { $0 as? ValidationError }.map { $0.message }
            whenStatusLabel.text = messages.joined(separator: "")
        }
    }
    
    private func updateValidationWhereState(result: ValidationResult) {
        switch result {
        case .valid:
            whereStatusLabel.text = "😀"
        case .invalid(let failures):
            let messages = failures.compactMap { $0 as? ValidationError }.map { $0.message }
            whereStatusLabel.text = messages.joined(separator: "")
        }
    }
    private func updateValidationWhyState(result: ValidationResult) {
        switch result {
        case .valid:
            whyStatusLabel.text = "😀"
        case .invalid(let failures):
            let messages = failures.compactMap { $0 as? ValidationError }.map { $0.message }
            whyStatusLabel.text = messages.joined(separator: "")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let activeField = activeField {
            activeField.resignFirstResponder()
        }
        keyboardDisappearObserver?.removeObserver(self)
        keyboardAppearObserver?.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keyboardAppearObserver?.addObserver(
            self,
            selector: #selector(referkeyboardWillShow(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        keyboardDisappearObserver?.addObserver(
            self,
            selector: #selector(referkeyboardWillHide(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
    }
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        if activeField == whereLabel {
            whereLabel.startVisible = false
        }
        oldActiveField = activeField
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    func getRecruiters() {
        toogleHUD(show: true)
        firstly {
            DataHandler.getRecruiters()
            }.done { recruiters in
                self.recruiters = recruiters
                self.tableView.reloadData()
                self.toogleHUD(show: false)
            }.catch { error in
                self.toogleHUD(show: false)
                print(error.localizedDescription)
                ErrorHandler.handle(spellError: error as NSError)
        }
    }
    
    func setUpView() {
        switchTypeReferral.setOn(true, animated: true)
        navigationItem.title = NSLocalizedString("Recruiters", comment: "")
        let title = NSLocalizedString("Send", comment: "")
        let btn = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(doneRefer))
        var btns: [UIBarButtonItem] = []
        btns.append(btn)
        navigationItem.setRightBarButtonItems(btns, animated: true)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func registerNibs() {
        let nib = UINib(nibName: RecruiterTableViewCell.reusableID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: RecruiterTableViewCell.reusableID)
    }
    
    func setUpToolBarDate() {
        let toolbarDate = UIToolbar()
        toolbarDate.sizeToFit()
        
        expiryDatePicker.onDateSelected = { [unowned self] (month: String, year: Int) in
            let date = String(format: "%@ %d", month, year)
            self.whenLabel.text = date
        }
        let okButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbarDate.setItems([okButton, spaceButton, cancelButton], animated: false)
        whenLabel.inputAccessoryView = toolbarDate
    }
    
    @objc func doneDatePicker() {
        activeField?.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        whenLabel.text = ""
        activeField?.endEditing(true)
    }
    
    @objc func doneRefer() {
        guard validateFields() == true else {
            return
        }
        let alert = UIAlertController(title: "Confirm", message: "Are you sure to refer?", preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionOk = UIAlertAction(title: "Refer", style: .default) { (_) in
            self.sendEmail()
        }
        alert.addAction(actionCancel)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func validateFields() -> Bool {
        guard let whenStatusLabel = whenStatusLabel.text,
            let whereStatusLabel = whereStatusLabel.text,
            let whyStatusLabel = whyStatusLabel.text,
            whereStatusLabel == "😀",
            whenStatusLabel == "😀",
            whyStatusLabel == "😀" else {
            let alert = UIAlertController(title: "Ups", message: "Remember fill out all required fields 😩", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
                return false
        }
        return true
    }
    
    func sendEmail() {
        let strong = switchTypeReferral.isOn
        let when = whenLabel.text!
        let whereWorked = whereLabel.text!
        let why = whyLabel.text!
        let recruiterID = String(describing: recruiter?.id)
        let referred = self.referred!
        firstly {
            DataHandler.sendRefer(
                strong: strong,
                year: when,
                month: when,
                whereWorked: whereWorked,
                why: why,
                recruiterId: recruiterID,
                referred: referred)
            }.done { _ in 
            }.catch { error in
                print(error.localizedDescription)
                ErrorHandler.handle(spellError: error as NSError)
        }
    }
    
    @IBAction func changeViewAction(_ sender: UISwitch) {
        stackStrongReferral.isHidden = !stackStrongReferral.isHidden
    }
    
    @objc func referkeyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomContraint.constant += self.keyboardHeight + (self.activeField?.frame.height ?? 0.0)
            })
            // move if keyboard hide input field
            let distanceToBottom = (self.scrollView.frame.size.height) - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom -  (self.oldActiveField?.frame.height ?? 0.0)
            if collapseSpace < 0 {
                // no collapse
                return
            }
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }
    
    @objc func referkeyboardWillHide(notification: NSNotification) {
        if let keyboardHeight = keyboardHeight {
            UIView.animate(withDuration: 0.3) {
                self.bottomContraint.constant -= keyboardHeight
                self.scrollView.contentOffset = self.lastOffset
            }
        }
        keyboardHeight = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let activeField = activeField {
            activeField.resignFirstResponder()
        }
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
        let cell = (tableView.dequeueReusableCell(withIdentifier: RecruiterTableViewCell.reusableID, for: indexPath) as? RecruiterTableViewCell)!
        cell.config(with: recruiters[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         recruiter = recruiters[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ReferViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        oldActiveField = activeField
        lastOffset = self.scrollView.contentOffset
        if textField == whenLabel {
            textField.inputView = expiryDatePicker
        } else if textField == whereLabel {
            whereLabel.startVisible = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}

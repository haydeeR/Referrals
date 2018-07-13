//
//  ReferViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/22/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import PromiseKit

class ReferViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchTypeReferral: UISwitch!
    @IBOutlet weak var stackStrongReferral: UIStackView!
    @IBOutlet weak var whenLabel: UITextField!
    @IBOutlet weak var whereLabel: UITextField!
    @IBOutlet weak var whyLabel: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    
    var referred: Referred?
    var recruiters: [Recruiter] = []
    var recruiter: Recruiter?
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    var keyboardAppearObserver: NotificationCenter?
    var keyboardDisappearObserver: NotificationCenter?
    let datePicker = UIDatePicker()
    
    
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
        setUpToolBarDate()
        registerNibs()
        getRecruiters()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let activeField = activeField {
            activeField.resignFirstResponder()
        }
        keyboardDisappearObserver?.removeObserver(self)
        keyboardAppearObserver?.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keyboardAppearObserver?.addObserver(self, selector: #selector(referkeyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        keyboardDisappearObserver?.addObserver(self, selector: #selector(referkeyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
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
                ErrorHandler.handle(spellError: ErrorType.connectivity)
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
    
    func registerNibs() {
        let nib = UINib(nibName: RecruiterTableViewCell.reusableID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: RecruiterTableViewCell.reusableID)
    }
    
    func setUpToolBarDate() {
        let toolbarDate = UIToolbar()
        toolbarDate.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Guardar", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbarDate.setItems([doneButton,spaceButton,cancelButton], animated: false)
        datePicker.datePickerMode = .date
        whereLabel.inputAccessoryView = toolbarDate
    }
    
    @objc func doneDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        whereLabel.text = dateFormatter.string(from: datePicker.date) + " ago"
    }
    
    @objc func cancelDatePicker() {
        activeField?.endEditing(true)
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
      //something that send an email
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
                self.bottomContraint.constant += self.keyboardHeight
            })
            // move if keyboard hide input field
            let distanceToBottom = (self.scrollView.frame.size.height) - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
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
        UIView.animate(withDuration: 0.3) {
            self.bottomContraint.constant -= self.keyboardHeight
            self.scrollView.contentOffset = self.lastOffset
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
        let cell = tableView.dequeueReusableCell(withIdentifier: RecruiterTableViewCell.reusableID, for: indexPath) as! RecruiterTableViewCell
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
        lastOffset = self.scrollView.contentOffset
        if textField == whereLabel {
            textField.inputView = datePicker
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}

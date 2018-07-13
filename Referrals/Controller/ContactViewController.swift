//
//  ContactViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/22/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var nameRefer: UITextField!
    @IBOutlet weak var emailRefer: UITextField!
    @IBOutlet weak var resumeRefer: UITextField!
    
    
    weak var delegate: PositionDetailViewController?
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    var keyboardAppearObserver: NotificationCenter?
    var keyboardDisappearObserver: NotificationCenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameRefer.delegate = self
        emailRefer.delegate = self
        resumeRefer.delegate = self
        
        // Observe keyboard change
        keyboardAppearObserver = NotificationCenter.default
        keyboardDisappearObserver = NotificationCenter.default
        
        
        // Add touch gesture for contentView
        self.delegate?.linkedInContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        keyboardDisappearObserver?.removeObserver(self)
        keyboardAppearObserver?.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keyboardAppearObserver?.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        keyboardDisappearObserver?.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        if let name = nameRefer?.text, let email = emailRefer?.text {
            delegate?.choseRecruiter(name: name, email: email)
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
        UIView.animate(withDuration: 0.3) {
            self.delegate?.bottomConstraint.constant -= self.keyboardHeight
            self.delegate?.scrollView.contentOffset = self.lastOffset
        }
        keyboardHeight = nil
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

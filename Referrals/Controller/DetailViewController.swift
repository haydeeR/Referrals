//
//  DetailViewController.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 8/3/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import Social
import FacebookShare

class DetailViewController: UIViewController {

    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var showPrizeButton: UIButton!
    
    var referred: Referred?
    var opening: Opening?
    var fields: [Field] = []
    var detailPrize: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadTextDescription()
    }
    
    func setUpView() {
        navigationItem.title = opening?.name
    }

    private func loadTextDescription() {
        guard let opening = opening else {
            return
        }
        var fullText = ""
        if  opening.requirements.isEmpty == false {
            let field = Field(fieldName: "Requirements", fieldDescription: opening.requirements)
            fields.append(field)
            fullText += "\(field.fieldName) \n \n \(field.fieldDescription) \n"
        }
        if  opening.responsabilities.isEmpty == false {
            let field = Field(fieldName: "Responsibilities", fieldDescription: opening.responsabilities)
            fields.append(field)
            fullText += "\(field.fieldName) \n \n \(field.fieldDescription) \n"
        }
        if  opening.skills.isEmpty == false {
            let field = Field(fieldName: "Skills", fieldDescription: opening.skills)
            fields.append(field)
            fullText += "\(field.fieldName) \n \n \(field.fieldDescription) \n"
        }
        if  opening.generals.isEmpty == false {
            let field = Field(fieldName: "Generals", fieldDescription: opening.generals)
            fields.append(field)
            fullText += "\(field.fieldName) \n \n \(field.fieldDescription) \n"
        }
        textDescription.text = fullText
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func pushLogout() {
       // AuthHandler.logOut(logoutVC: self)
    }
    
    @IBAction func sendReferral() {
        performSegue(withIdentifier: SegueIdentifier.detailtoCreateRefer.rawValue, sender: nil)
    }
    
    @IBAction func shareByWhatsapp() {
        let whatsappURL:NSURL? = NSURL(string: "whatsapp://send?text=Hello%2C%20Maybe%20this%20opening%20is%20for%20you!")
        if (UIApplication.shared.canOpenURL(whatsappURL! as URL)) {
            UIApplication.shared.openURL(whatsappURL! as URL)
        }
    }
    
    @IBAction func shareByLinkedin() {
        
    }
    
    @IBAction func shareByGmail() {
        
    }
    
    @IBAction func shareByTwitter() {
        let socialViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        socialViewController?.add(URL(string: APIManager.linkToShare))
        socialViewController?.setInitialText("Hey look out this positions")
        self.present(socialViewController!, animated: true, completion: nil)
    }
    
    @IBAction func shareByFacebook() {
        let content = LinkShareContent(url: URL(string: APIManager.linkToShare)!)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
        }
        do {
            try shareDialog.show()
        } catch {
            print(error)
        }
    }
    
    @IBAction func readMore(_ sender: UIButton) {
        if detailPrize {
            showPrizeButton.imageView?.image = #imageLiteral(resourceName: "Down")
        } else {
            showPrizeButton.imageView?.image = #imageLiteral(resourceName: "Up")
        }
        detailPrize = !detailPrize
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

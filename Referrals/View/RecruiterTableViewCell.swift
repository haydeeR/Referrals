//
//  RecruiterTableViewCell.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 7/6/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit
import AlamofireImage

class RecruiterTableViewCell: UITableViewCell {

    @IBOutlet weak var imageRecruiter: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(with data: Recruiter) {
        imageRecruiter.layer.cornerRadius = imageRecruiter.bounds.size.width / 2.0
        rightLabel.text = data.name
        if let url = URL(string: data.picture) {
            imageRecruiter.af_setImage(withURL: url)
        } else {
            imageRecruiter.image = #imageLiteral(resourceName: "default-recruiter")
        }
    }
    
}

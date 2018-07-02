//
//  PositionTableViewCell.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 6/13/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit

class PositionTableViewCell: UITableViewCell {

    @IBOutlet weak var nameFieldLabel: UILabel!
    @IBOutlet weak var descriptionFieldLabel: UILabel!
   
    func config(with data: Field) {
        nameFieldLabel.text = data.fieldName
        descriptionFieldLabel.text = data.fieldDescription
    }
    
}

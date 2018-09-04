//
//  ReferedTableViewCell.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 9/3/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import UIKit

class ReferedTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var labelUp: UILabel!
    @IBOutlet weak var labelDown: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

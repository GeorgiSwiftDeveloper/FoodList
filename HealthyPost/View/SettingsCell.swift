//
//  SettingsCell.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 6/9/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var settingsLbl: UILabel!
    @IBOutlet weak var settingsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

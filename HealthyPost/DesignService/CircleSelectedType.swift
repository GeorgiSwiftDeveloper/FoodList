//
//  CircleSelectedType.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 6/8/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import UIKit




class SelectedTypeRound: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = self.frame.size.width / 2.2
        layer.masksToBounds = true
        self.layer.shadowOpacity = 0.70
        self.layer.borderWidth = 0
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
    }
}

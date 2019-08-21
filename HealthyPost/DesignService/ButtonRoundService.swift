//
//  ButtonRoundService.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 6/8/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import  UIKit


class ButtonRoundService: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.cornerRadius = self.frame.size.width / 2
        layer.masksToBounds = true
    }
    
    
}

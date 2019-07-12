//
//  ButtonRoundService.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 6/8/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import  UIKit


class ButtonRoundService: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = self.frame.size.width / 2
        layer.masksToBounds = true
    }
    
    
}

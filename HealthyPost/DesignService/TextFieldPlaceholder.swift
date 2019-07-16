//
//  TextFieldPlaceholder.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 6/10/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import UIKit
class TextColorChange: UITextField {
    override func awakeFromNib() {
//        self.attributedPlaceholder = NSAttributedString(string: "User name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        super.awakeFromNib()
    }
    
}

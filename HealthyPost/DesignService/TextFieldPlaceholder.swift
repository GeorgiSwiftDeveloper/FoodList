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
        self.attributedPlaceholder = NSAttributedString(string: "User name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        super.awakeFromNib()
    }
    
}

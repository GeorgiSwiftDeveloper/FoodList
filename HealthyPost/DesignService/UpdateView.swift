//
//  UIViewDesign.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 3/20/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import UIKit
class ServiceView: UIView {
    override func awakeFromNib() {
        self.layer.shadowOpacity = 0.70
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.shadowRadius = 7
        self.layer.shadowColor = UIColor.black.cgColor
        super.awakeFromNib()
    }
    
}

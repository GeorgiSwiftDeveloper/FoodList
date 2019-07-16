//
//  CircleImage.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 6/10/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import UIKit


class CircleImage: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.borderWidth = 1
        layer.cornerRadius = self.frame.size.width / 2
        layer.masksToBounds = true
    }
}

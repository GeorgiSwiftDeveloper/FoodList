//
//  ImageService.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 3/2/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit

class ImageService: UIImageView {
    override func awakeFromNib() {
        layer.borderWidth = 3
        layer.masksToBounds = false
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.cornerRadius = 5
        self.clipsToBounds = true
    }

}

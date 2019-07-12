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
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.cornerRadius = self.frame.size.height/2.5
        self.clipsToBounds = true
    }

}

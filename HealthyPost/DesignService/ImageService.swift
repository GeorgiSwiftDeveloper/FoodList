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
        layer.borderWidth = 2
        layer.masksToBounds = false
        layer.borderColor = #colorLiteral(red: 0.3223614839, green: 0.8253351772, blue: 0.4431372549, alpha: 1)
        layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }

}

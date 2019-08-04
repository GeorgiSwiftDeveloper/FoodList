//
//  ButtonUIService.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 2/26/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit

class ButtonUIService: UIButton {
 
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
//        self.setTitleColor(UIColor.white, for: .normal)
        layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
    }
    
    class ButtonHeaderView: ButtonUIService {
        
    }

}

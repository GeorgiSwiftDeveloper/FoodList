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
        layer.cornerRadius = 7
//        self.setTitleColor(UIColor.white, for: .normal)
        layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
    }
    
    class ButtonHeaderView: ButtonUIService {
        
    }

}

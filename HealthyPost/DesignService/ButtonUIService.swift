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
        layer.cornerRadius = 2
        layer.shadowColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 2
    }
    
    class ButtonHeaderView: ButtonUIService {
        
    }

}

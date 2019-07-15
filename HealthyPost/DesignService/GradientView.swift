//
//  GradientView.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 7/15/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
@IBDesignable
class GradientView: UIView {

    @IBInspectable var topColor: UIColor = UIColor.blue {
        didSet{
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = UIColor.green {
        didSet{
            self.setNeedsLayout()
        }
    }
   
    
    override func layoutSubviews() {
        let grandientLayer = CAGradientLayer()
        grandientLayer.colors = [topColor.cgColor, bottomColor.cgColor, topColor.cgColor]
        grandientLayer.startPoint = CGPoint(x: 0.5, y: 0.4)
        grandientLayer.endPoint = CGPoint(x: 1, y: 1)
        grandientLayer.frame = self.bounds
        self.layer.insertSublayer(grandientLayer, at: 0)
    }

}

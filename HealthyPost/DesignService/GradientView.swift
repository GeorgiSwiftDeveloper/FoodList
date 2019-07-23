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

    @IBInspectable var topColor: UIColor = UIColor.white {
        didSet{
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = UIColor.green {
        didSet{
            self.setNeedsLayout()
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOffSetWidth: Int = 0
    @IBInspectable var shadowOffSetHeight: Int = 1
    @IBInspectable var shadowOpacity: Float = 0.2
    
    
    
    override func layoutSubviews() {
        let grandientLayer = CAGradientLayer()
        grandientLayer.colors = [topColor.cgColor, bottomColor.cgColor, topColor.cgColor]
        grandientLayer.startPoint = CGPoint(x: 0.3, y: 0.4)
        grandientLayer.endPoint = CGPoint(x: 1, y: 1)
        grandientLayer.frame = self.bounds
        self.layer.insertSublayer(grandientLayer, at: 0)
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = shadowOpacity
    }

}

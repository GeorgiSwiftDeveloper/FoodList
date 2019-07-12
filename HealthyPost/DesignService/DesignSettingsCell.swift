//
//  DesignSettingsCell.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 6/9/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import  UIKit

@IBDesignable class DesignSettingsUIView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0
    
        @IBInspectable var shadowColor: UIColor? = UIColor.black
        @IBInspectable var shadowOffSetWidth: Int = 0
        @IBInspectable var shadowOffSetHeight: Int = 1
        @IBInspectable var shadowOpacity: Float = 0.2
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
                layer.shadowColor = shadowColor?.cgColor
                layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
                let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
                layer.shadowPath = shadowPath.cgPath
                layer.shadowOpacity = shadowOpacity
    }
    
}

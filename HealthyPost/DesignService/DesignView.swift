//
//  DesignView.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 3/20/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import  UIKit

@IBDesignable class DesignView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 3
    
//    @IBInspectable var shadowColor: UIColor? = UIColor.gray
//    @IBInspectable var shadowOffSetWidth: Int = 0
//    @IBInspectable var shadowOffSetHeight: Int = 1
//    @IBInspectable var shadowOpacity: Float = 0.8
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
//        layer.shadowColor = shadowColor?.cgColor
//        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//        layer.shadowPath = shadowPath.cgPath
//        layer.shadowOpacity = shadowOpacity
//        layer.borderWidth = 1
//        layer.borderColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
}

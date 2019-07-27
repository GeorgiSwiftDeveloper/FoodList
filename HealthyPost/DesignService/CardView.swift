//
//  CardView.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 4/15/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import Foundation
//
//@IBDesignable class CardView: UIView {
//
//    @IBInspectable var cornerRadius: CGFloat = 5
//    @IBInspectable var shadowOffSetWidth : CGFloat = 0
//    @IBInspectable var shadowOfSetHeight: CGFloat = 2
//    @IBInspectable var shadowColor: UIColor = UIColor.gray
//    @IBInspectable var  shadowOpacity:  CGFloat = 0.3
//    
//
//
//    override func layoutSubviews() {
//        layer.cornerRadius = cornerRadius
//        layer.shadowColor = shadowColor.cgColor
//        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOfSetHeight)
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//        layer.shadowPath = shadowPath.cgPath
//        layer.shadowOpacity = Float(shadowOpacity)
//    }
//
//}
class CardView: UIView {
    let contentView = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureAll()
    }
    
    // MARK: - Configuration
    
    private func configureAll() {
        configureCell()
    }
    
    private func configureCell() {
//        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = self.contentView.layer.cornerRadius
    }
}

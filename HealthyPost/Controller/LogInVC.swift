//
//  LogInVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 7/23/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {

    @IBOutlet weak var appNameTitle: UILabel!
    @IBOutlet weak var appDescriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        changeAppNameTxtFormat()
    }
    
    func changeAppNameTxtFormat() {
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: appNameTitle.text as! String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 55)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.2471, green: 0.549, blue: 0, alpha: 1.0) , range: NSRange(location:3,length:1))
        appNameTitle.attributedText = myMutableString
        var mutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: appDescriptionLbl.text as! String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 25)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.2471, green: 0.549, blue: 0, alpha: 1.0) , range: NSRange(location:3,length:1))
        appDescriptionLbl.attributedText = myMutableString
    }


}

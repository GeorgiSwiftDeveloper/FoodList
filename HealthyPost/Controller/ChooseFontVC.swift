//
//  ChooseFontVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 5/17/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit

class ChooseFontVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    @IBOutlet weak var fontEditLbl: UILabel!
    @IBOutlet weak var fontPIckerView: UIPickerView!
    @IBOutlet weak var sliderLbl: UISlider!
    @IBOutlet weak var sizeLbl: UILabel!
    
    
    let fontNames = UIFont.familyNames
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createSlider()
    }
    
    
    func createSlider() {
        sliderLbl.addTarget(self, action: #selector(changeslidervalue(_:)), for: .valueChanged)
    }
    var selectedFont = String()
    
    
    @objc func changeslidervalue(_ sender: UISlider) {
        fontEditLbl.font = UIFont(name: selectedFont , size: CGFloat(sender.value))
        sizeLbl.text = String(Int(sender.value))
    }
    
   
    @IBAction func saveFontBtn(_ sender: Any) {
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fontNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fontEditLbl.font = UIFont(name: fontNames[row], size: 18)
        selectedFont  = fontNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = fontNames[row]
        let myTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 15.0)!, NSAttributedString.Key.foregroundColor:UIColor.black])
        return myTitle
    }
}

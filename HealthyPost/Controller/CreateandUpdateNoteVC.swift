//
//  CreateMealVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 7/15/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import CoreData

class CreateandUpdateNoteVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var creatOrEditnoteLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var selectPostType: UISegmentedControl!
    @IBOutlet weak var chooseTimeBtn: UIButton!
    @IBOutlet weak var caloriaTextField: UITextField!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var pickerView: CardView!
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var mainView: UIView!
    
    
    
    var brandName = [String]()
    
    
    var selectedTime = Date()
    var postType: PostType? = nil
    var coreDataModel = CoreDataStackClass()
    var health: HealthModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: creatOrEditnoteLabel.text as! String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30)!])
         myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.2471, green: 0.549, blue: 0, alpha: 1.0) , range: NSRange(location:3,length:1))
         creatOrEditnoteLabel.attributedText = myMutableString
        chooseTimeBtn.setTitle("\(DateService.service.pickerDate(date: selectedTime ))", for: .normal)
        picker.date = selectedTime
        setUIforEdit()
        saveFoodNote()
    }
    
    func setUIforEdit() {
        self.descriptionTextField.text = health?.brandName
        self.commentTextField.text = health?.userComment
        self.caloriaTextField.text = health?.calorie
        if let time = health?.postTime {
            self.chooseTimeBtn.setTitle("\(DateService.service.pickerDate(date: time))", for: .normal)
        }
        
        if health?.selectedType == "bad" {
            selectPostType.selectedSegmentIndex = 1
            selectPostType.tintColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 0.8394243673)
            postType = .notHealthy
        }else if health?.selectedType == "good"{
            selectPostType.selectedSegmentIndex = 0
            selectPostType.tintColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
            postType = .healthy
        }
    }
    
    
    @IBAction func closePickerView(_ sender: Any) {
        pickerView.isHidden = true
        picker.isHidden = true
    }

    @IBAction func timeBtnAction(_ sender: Any) {
        picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        picker.addTarget(self, action: #selector(dataPickerValueChanged(sender:)), for: .valueChanged)
        pickerView.isHidden = false
        picker.isHidden = false
    }
    
    @objc func dataPickerValueChanged(sender: UIDatePicker) {
        self.chooseTimeBtn.setTitle("\(DateService.service.pickerDate(date: sender.date))", for: .normal)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
//    func searchBarUIDesign() {
//        searchBar.layer.cornerRadius = 15
//        searchBar.clipsToBounds = true
//        searchBar.layer.borderColor = #colorLiteral(red: 0.9099021554, green: 0.3283959627, blue: 0.4355659187, alpha: 1)
//        searchBar.layer.borderWidth = 1
//        // TextField Color Customization
//        let textFieldInsideSearchBar =  searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        // Glass Icon Customization
//        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
//        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
//        glassIconView?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    }
    
    
    @IBAction func selectedPostTypeAction(_ sender: UISegmentedControl) {
        switch selectPostType.selectedSegmentIndex {
        case 0:
            postType = .healthy
            selectPostType.tintColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        case 1:
            postType = .notHealthy
            selectPostType.tintColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 0.8394243673)
        default:
            postType = nil
        }
    }
    
    
    func saveFoodNote() {
        if health == nil  && descriptionTextField.text != "" && commentTextField.text != "" && caloriaTextField.text != "" && postType != nil  {
            
            let managedContext = coreDataModel.persistentContainer.viewContext
            let entity =  NSEntityDescription.entity(forEntityName: "HealthModel", in:managedContext)
            let item = NSManagedObject(entity: entity!, insertInto:managedContext)
            item.setValue(picker.date, forKey: "postTime")
            item.setValue(descriptionTextField.text, forKey: "brandName")
            item.setValue(commentTextField.text, forKey: "userComment")
            item.setValue(postType?.rawValue, forKey: "selectedType")
            item.setValue(caloriaTextField.text, forKey: "calorie")
        }else {
            health?.brandName = self.descriptionTextField.text
            health?.userComment = self.commentTextField.text
            health?.calorie = self.caloriaTextField.text
            health?.postTime = picker.date
            health?.selectedType = postType?.rawValue
            self.dismiss(animated: true, completion: nil)
        }
       
        do {
            let managedContext = coreDataModel.persistentContainer.viewContext
            try managedContext.save()
        }catch {
            print("Can not save note \(error)")
        }
    }
    
    @IBAction func saveMeals(_ sender: Any) {
        if descriptionTextField.text != "" && postType != nil {
            self.saveFoodNote()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelCreateMealVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

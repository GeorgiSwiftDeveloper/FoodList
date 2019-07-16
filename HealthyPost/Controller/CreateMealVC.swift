//
//  CreateMealVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 7/15/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import CoreData

class CreateMealVC: UIViewController {

    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var selectPostType: UISegmentedControl!
    @IBOutlet weak var chooseTimeBtn: UIButton!
    @IBOutlet weak var caloriaTextField: UITextField!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var pickerView: CardView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var closePickerBtn: UIButton!
    @IBOutlet var mainView: UIView!
    
    
    
    var brandName = [String]()
    var itemArray = [HealthModel]()
    var selectedTime = Date()
    var postType: PostType? = nil
    var coreDataModel = CoreDataStackClass()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(mainViewGesture(_:)))
        view.addGestureRecognizer(tap)
        searchBarUIDesign()
        
        chooseTimeBtn.setTitle("\(DateService.service.pickerDate(date: Date()))", for: .normal)
        chooseTimeBtn.setTitle("\(DateService.service.pickerDate(date: selectedTime ))", for: .normal)
    }
    
    
    
    @objc func mainViewGesture(_ sender: UIGestureRecognizer){
      
        view.endEditing(true)
    }
    @IBAction func timeBtnAction(_ sender: Any) {
        picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        picker.addTarget(self, action: #selector(dataPickerValueChanged(sender:)), for: .valueChanged)
        mainView.backgroundColor = #colorLiteral(red: 0.9099021554, green: 0.3283959627, blue: 0.4355659187, alpha: 1)
        closePickerBtn.isHidden = false
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
    
    
    func searchBarUIDesign() {
        searchBar.layer.cornerRadius = 15
        searchBar.clipsToBounds = true
        searchBar.layer.borderColor = #colorLiteral(red: 0.9099021554, green: 0.3283959627, blue: 0.4355659187, alpha: 1)
        searchBar.layer.borderWidth = 1
        // TextField Color Customization
        let textFieldInsideSearchBar =  searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        // Glass Icon Customization
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    
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
        let managedContext = coreDataModel.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "HealthModel", in:managedContext)
        let item = NSManagedObject(entity: entity!, insertInto:managedContext)
        item.setValue(picker.date, forKey: "postTime")
        item.setValue(descriptionTextField.text, forKey: "brandName")
        item.setValue(commentTextField.text, forKey: "userComment")
        item.setValue(postType?.rawValue, forKey: "selectedType")
        item.setValue(caloriaTextField.text, forKey: "calorie")
        do {
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
    
    @IBAction func clousePicker(_ sender: Any) {
        mainView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        picker.isHidden = true
        pickerView.isHidden = true
        closePickerBtn.isHidden = true
    }
}

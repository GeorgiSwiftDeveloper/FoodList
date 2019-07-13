//
//  CreateNoteVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 2/26/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import CoreData


class CreateNoteVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var selectPostType: UISegmentedControl!
    @IBOutlet weak var chooseTimeBtn: UIButton!
    @IBOutlet weak var pickerView: CardView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var caloriaTextField: UITextField!
    
    
    
    
    
    var selectedTime = Date()
    var postType: PostType? = nil
    var coreDataModel = CoreDataStackClass()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        let tap = UITapGestureRecognizer(target: self, action: #selector(mainViewGesture(_:)))
        mainView.addGestureRecognizer(tap)
       
        
        chooseTimeBtn.setTitle("\(DateService.service.pickerDate(date: Date()))", for: .normal)
        chooseTimeBtn.setTitle("\(DateService.service.pickerDate(date: selectedTime ))", for: .normal)
        picker.date = selectedTime
        
    }
  
    @objc func mainViewGesture(_ sender: UIGestureRecognizer){
        pickerView.isHidden = true
        picker.isHidden = true
    }
    
    
    @IBAction func dissmissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    
    @IBAction func createFoodBtnAction(_ sender: UIButton) {
        if descriptionTextField.text != "" && postType != nil {
            self.saveFoodNote()
            self.dismiss(animated: true, completion: nil)
        }
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

}

extension CreateNoteVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

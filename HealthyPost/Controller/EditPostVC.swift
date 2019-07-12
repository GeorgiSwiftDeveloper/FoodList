//
//  EditPost.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 6/6/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import CoreData

class EditPostVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var postTime: UIButton!
    @IBOutlet weak var selectedType: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mainView: UIView!
    
    
    var selectedTime = Date()
    var postType: PostType? = nil
    var coreDataModel = CoreDataStackClass()
    var health: HealthModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        let tap = UITapGestureRecognizer(target: self, action: #selector(mainViewGesture(_:)))
        mainView.addGestureRecognizer(tap)
        
        postTime.setTitle("\(DateService.service.pickerDate(date: Date()))", for: .normal)
        postTime.setTitle("\(DateService.service.pickerDate(date: selectedTime ))", for: .normal)
        datePicker.date = selectedTime
        
        setUIforEdit()
    }
    
    
    func setUIforEdit() {
        self.descriptionText.text = health?.brandName
        self.commentText.text = health?.userComment
        if let time = health?.postTime {
             self.postTime.setTitle("\(DateService.service.pickerDate(date: time))", for: .normal)
        }
//        switch health?.selectedType {
//        case "good":
//                selectedType.selectedSegmentIndex = 0
//                selectedType.tintColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
//                selectedType.isSelected = true
//        case "bad":
//                selectedType.selectedSegmentIndex = 1
//                selectedType.tintColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 0.8394243673)
//                selectedType.isSelected = true
//
//        default:
//            break
//        }
        
        if health?.selectedType == "bad" {
            selectedType.selectedSegmentIndex = 1
            selectedType.tintColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 0.8394243673)
             postType = .notHealthy
        }else if health?.selectedType == "good"{
             selectedType.selectedSegmentIndex = 0
            selectedType.tintColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
             postType = .healthy
        }
    }
    
    @objc func mainViewGesture(_ sender: UIGestureRecognizer){
        datePicker.isHidden = true
    }
    
    @IBAction func postTimeSelectedBtn(_ sender: Any) {
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.addTarget(self, action: #selector(dataPickerValueChanged(sender:)), for: .valueChanged)
        datePicker.isHidden = false
    }
    @objc func dataPickerValueChanged(sender: UIDatePicker) {
        self.postTime.setTitle("\(DateService.service.pickerDate(date: sender.date))", for: .normal)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func selectedType(_ sender: Any) {
        
        switch selectedType.selectedSegmentIndex {
        case 0:
            postType = .healthy
            selectedType.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case 1:
            postType = .notHealthy
            selectedType.tintColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        default:
            postType = nil
        }
    }
    
    @IBAction func dissmissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitEditBtn(_ sender: Any) {
        
        self.health?.brandName = descriptionText.text
        self.health?.userComment = commentText.text
        self.health?.postTime = health?.postTime
        self.health?.selectedType = postType?.rawValue
        save()
        self.dismiss(animated: true, completion: nil)
    }
    
    func save(){
        do {
            try self.health?.managedObjectContext?.save()
        } catch  {
            print("error")
        }
    
    }
}

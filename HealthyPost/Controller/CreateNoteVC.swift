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
    @IBOutlet weak var tableViewDropDown: UITableView!

    
    
    
    var brandName = [String]()
    var itemArray = [HealthModel]()
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
        let dissmisKeyBoard = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        mainView.addGestureRecognizer(dissmisKeyBoard)
        loadItems()
    }
    
   @objc func dismissKey() {
        view.endEditing(true)
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
    
    func loadItems(with request: NSFetchRequest<HealthModel> = HealthModel.fetchRequest()) {
           let managedContext = coreDataModel.persistentContainer.viewContext
        do {
            itemArray = try managedContext.fetch(request)
            for item in itemArray {
                brandName = [item.brandName ?? ""]
                print(brandName)
            }
        } catch  {
             print("cant fetch items")
        }
    }

}

extension CreateNoteVC: UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<HealthModel> = HealthModel.fetchRequest()
        request.predicate = NSPredicate(format: "brandName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "brandName", ascending: true)]
        loadItems(with: request)
        tableViewDropDown.reloadData()
        tableViewDropDown.isHidden = false
    }
 
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableViewDropDown.isHidden = true
            searchBar.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "dropCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "dropCell")
        }
        cell?.textLabel?.text = brandName[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
}

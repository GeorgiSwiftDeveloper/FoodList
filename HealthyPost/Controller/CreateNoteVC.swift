//
//  CreateNoteVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 8/3/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import CoreData

class CreateNoteVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    
    let descText = UITextField()
    let commentText = UITextField()
    let calorieTxt = UITextField()
    let datePicker = UIDatePicker()
    let segmentedControl = UISegmentedControl()
    
    var coreDataModel = CoreDataStackClass()
    var postType: PostType? = nil
    var healthEditReciver: HealthModel?
    
    
    
    let sections = ["Descriiption", "Comment(Optional)", "Calorie(Optional)","Time","Is it Healthy ? "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.insertSegment(withTitle: "YES", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "NO", at: 1, animated: true)
        setUIforEdit()
    }
    
    
    func setUIforEdit() {
        self.descText.text = healthEditReciver?.brandName
        self.commentText.text = healthEditReciver?.userComment
        self.calorieTxt.text = healthEditReciver?.calorie
        if let time = healthEditReciver?.postTime {
           datePicker.date = time
            if healthEditReciver?.selectedType == "bad" {
                segmentedControl.selectedSegmentIndex = 1
                segmentedControl.tintColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 0.8394243673)
                postType = .notHealthy
            }else if healthEditReciver?.selectedType == "good"{
                segmentedControl.selectedSegmentIndex = 0
                segmentedControl.tintColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
                postType = .healthy
            }
        }
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == calorieTxt {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Verdana", size: 12)!
        header.textLabel?.textColor = UIColor.black
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell
        tableView.rowHeight = 70
        switch indexPath.section {
        case 0:
            descText.frame = CGRect(x: 0, y: 0, width: 414, height: 70)
            descText.placeholder = "Enter product descriptiion"
            descText.font = UIFont.systemFont(ofSize: 15)
            descText.delegate = self
            descText.textAlignment = .center
            //cell.contentView.addSubview(tf)
            cell?.addSubview(descText)
            
            break
        case 1:
            commentText.frame = CGRect(x: 0, y: 0, width: 414, height: 70)
            commentText.placeholder = "Enter product comment here"
            commentText.font = UIFont.systemFont(ofSize: 15)
            commentText.delegate = self
            commentText.textAlignment = .center
            //cell.contentView.addSubview(tf)
            cell?.addSubview(commentText)

            break
        case 2:
            tableView.rowHeight = 40
            calorieTxt.frame = CGRect(x: 0, y: 0, width: 414, height: 40)
            calorieTxt.placeholder = "ex 200 cl"
            calorieTxt.font = UIFont.systemFont(ofSize: 15)
            calorieTxt.delegate = self
            calorieTxt.textAlignment = .center
            //cell.contentView.addSubview(tf)
            cell?.addSubview(calorieTxt)

            break
        case 3:
             tableView.rowHeight = 180
             datePicker.frame = CGRect(x: 0, y: 0, width: 414, height: 180)
             datePicker.date = Date()
             cell?.addSubview(datePicker)
            break
        case 4:
            tableView.rowHeight = 50
            cell?.textLabel?.text = "Select your choice"
            segmentedControl.frame = CGRect(x: 240, y: 10, width: 150, height: 30)
            segmentedControl.addTarget(self, action: #selector(selectedPostTypeAction(_:)), for: .valueChanged)
            segmentedControl.layer.cornerRadius = 5
            segmentedControl.backgroundColor = .white
            segmentedControl.tintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            cell?.addSubview(segmentedControl)
            break
        default:
            break
        }
        return cell!
    }
    
    @objc func selectedPostTypeAction(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            postType = .healthy
            segmentedControl.tintColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        case 1:
            postType = .notHealthy
            segmentedControl.tintColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 0.8394243673)
        default:
            postType = nil
        }
    }

    @IBAction func saveBtnAction(_ sender: Any) {
        if descText.text != "" && postType != nil {
            self.saveFoodNote()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func saveFoodNote() {
        if healthEditReciver == nil  && descText.text != ""  && postType != nil  {
            
            let managedContext = coreDataModel.persistentContainer.viewContext
            let entity =  NSEntityDescription.entity(forEntityName: "HealthModel", in:managedContext)
            let item = NSManagedObject(entity: entity!, insertInto:managedContext)
            item.setValue(datePicker.date, forKey: "postTime")
            item.setValue(descText.text, forKey: "brandName")
            item.setValue(commentText.text, forKey: "userComment")
            item.setValue(postType?.rawValue, forKey: "selectedType")
            item.setValue(calorieTxt.text, forKey: "calorie")
        }else {
            healthEditReciver?.brandName = self.descText.text
            healthEditReciver?.userComment = self.commentText.text
            healthEditReciver?.calorie = self.calorieTxt.text
            healthEditReciver?.postTime = datePicker.date
            healthEditReciver?.selectedType = postType?.rawValue
            self.dismiss(animated: true, completion: nil)
        }
        
        do {
            let managedContext = coreDataModel.persistentContainer.viewContext
            try managedContext.save()
        }catch {
            print("Can not save note \(error)")
        }
    }
}

//
//  SettingsVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 6/9/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    
    
    
    
    
    let settingsList = ["Your Goal","Smart Notification","Clear data","Follow on Instagram", "Follow on Facebook", "Follow on Twitter", "Support Developer","Team"]
    let settingsImage = ["goal","notification","data","instagram","facebook","twitter","message","team"]
    
    
    
    
    

    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var addUserPhoto: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var todayDateLbl: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var designSettingsView: UIView!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var goalTextField: UITextField!
    //    var goalTextField = UITextField()
    
    @IBOutlet var backroundView: UIView!
    
    
    
        var coreDataModel = CoreDataStackClass()
        var goal = [Goal]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = UserDefaults.standard.object(forKey: "image")  {
            userImage.image = UIImage(data: data as! Data)
        }
        if let userName = UserDefaults.standard.object(forKey: "userName")  {
            userNameTextField.text = userName as? String
        }
        if userImage.image == nil {
            userImage.image = UIImage(named: "addPhoto")
        }
        userImage.layer.cornerRadius = 4

        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneEditing))
        let flexibaleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        userNameTextField.inputAccessoryView = toolBar
        toolBar.setItems([flexibaleSpace,doneButton], animated: true)
        toolBar.sizeToFit()
        userNameTextField.delegate = self
        
        
        
        todayDateLbl.text = "\(DateService.service.crrentDateTime())"
        settingsTableView.separatorColor = UIColor(white: 0.95, alpha: 1)
    }
    
    @objc func doneEditing() {
        view.endEditing(true)
        UserDefaults.standard.set(userNameTextField.text, forKey: "userName")
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        UserDefaults.standard.set(userNameTextField.text, forKey: "userName")
    }
    

    @IBAction func saveUserGoalBtn(_ sender: Any) {
        if goalTextField.text != ""  {
            saveGoal()
            goalView.isHidden = true
            settingsTableView.alpha = 1
            settingsTableView.reloadData()
        }else {
            goalTextField.placeholder = "Your goal is not created"
        }
        
    }
    
    @IBAction func cancelUserGoalBtn(_ sender: Any) {
        goalView.isHidden = true
        settingsTableView.alpha = 1
        settingsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsCell else {return  UITableViewCell()}
        cell.settingsLbl.text = settingsList[indexPath.row]
        cell.settingsImage.image = UIImage(named: settingsImage[indexPath.row])
//        cell.settingsLbl.textColor  = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
//        
        return cell
    }
    
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            goalView.isHidden = false
            settingsTableView.alpha = 0.3
        }
    }
    
    @IBAction func goBackBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func imageBtnTapped(_ sender: Any) {
        let imagepickerController = UIImagePickerController()
        imagepickerController.delegate = self
        let imageAlert = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        imageAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagepickerController.sourceType = .camera
                self.present(imagepickerController, animated: true, completion: nil)
            }else {
                print("camera not available")
            }
        }))
        imageAlert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagepickerController.sourceType = .photoLibrary
            self.present(imagepickerController, animated: true, completion: nil)
        }))
        imageAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        self.present(imageAlert, animated: true, completion: nil)
    }
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            userImage.image = selectedImage
            let dataImage = selectedImage?.pngData()
            UserDefaults.standard.set(dataImage, forKey: "image")
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func saveGoal() {
        let managedContext = coreDataModel.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "Goal", in:managedContext)
        let goal = NSManagedObject(entity: entity!, insertInto:managedContext)
        goal.setValue(goalTextField.text, forKey: "goalText")
        do {
            try managedContext.save()
        } catch  {
            print("error")
        }
    }
    

}

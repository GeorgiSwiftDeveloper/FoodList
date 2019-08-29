//
//  SettingsViewController.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 8/29/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import UIKit
import CoreData

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private var coreDataModel = CoreDataStackClass()
    
    
    private let sectionSettings = ["Personal Information", "General Settings"]
    private let settingsArray = ["Goal","Notification","Privacy","Follow on Instagram", "Follow on Twitter","Support/Developer"]
    
    
    var goalText = UITextField()
    var userImage = UIImageView()
    var userName = UITextField()
    var userEmail = UITextField()
    
    var editeButton = UIButton()
    
    
    var userProffileData =  [ProffileData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserProffileData()
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionSettings.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionSettings[section]
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Verdana", size: 15)!
        header.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  {
            return 1
        }else {
            return settingsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        switch indexPath.section {
        case 0:
            userImage.frame = CGRect(x: 15, y: 10, width: 70, height: 70)
            self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
            self.userImage.clipsToBounds = true
            self.userImage.contentMode = .scaleAspectFill
            cell.addSubview(userImage)
            
            userName.frame = CGRect(x: 90, y: 10, width: 270, height: 30)
            userName.placeholder = "User profile name"
            userName.textAlignment = .center
            userName.isUserInteractionEnabled = false
            cell.addSubview(userName)
            
            
            userEmail.frame = CGRect(x: 90, y: 50, width: 270, height: 30)
            userEmail.placeholder = "foodzila@gmail.com"
            userEmail.textAlignment = .center
            userEmail.isUserInteractionEnabled = false
            cell.addSubview(userEmail)
            
            tableView.rowHeight = 90
            cell.accessoryType = .disclosureIndicator
            break
        case 1 :
            tableView.rowHeight = 60
            let settingsIndexpath = settingsArray[indexPath.row]
            cell.textLabel?.text = settingsIndexpath
            cell.textLabel?.font = UIFont(name: "Verdana", size: 15)
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            break
        default:
            break
        }
        return cell
    }
    
    
    
    //MARK: TableView DidSelect function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                performSegue(withIdentifier: "profileSettings", sender: userProffileData)
            }
            break
        case 1:
            if indexPath.row == 0{
                let alert = UIAlertController(title: "Add your GOAL here", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    if self.goalText.text != ""  {
                        self.saveFunc()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                alert.addTextField { (textfield) in
                    self.goalText = textfield
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(action)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            }
            break
        default:
            break
        }
        
    }
    
    //MARK: CORE DATA Fetch user results
    func fetchUserProffileData(){
        let request: NSFetchRequest<ProffileData> = ProffileData.fetchRequest()
        do {
            userProffileData = try (managedContexts?.fetch(request))!
            for proffile in userProffileData {
                userImage.image = UIImage(data: (proffile.userImage)! as Data)
                userName.text = proffile.userName
                userEmail.text = proffile.userEmail
                if proffile.userImage == nil {
                    self.userImage.image = UIImage(named: "smackProfileIcon")
                }
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    //MARK: CORE DATA Save user results
    func saveFunc() {
        let managedContext = coreDataModel.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "Goal", in:managedContext)
        let item = NSManagedObject(entity: entity!, insertInto:managedContext)
        item.setValue(goalText.text, forKey: "goalText")
        do {
            try managedContext.save()
        }catch {
            print("Can not save note \(error)")
        }
    }
    
}

//
//  SettingsTableView.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 5/16/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class SettingsTableView: UITableViewController {

    @IBOutlet weak var createGoalSwitch: UISwitch!
    var goalText = UITextField()
    var coreDataModel = CoreDataStackClass()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createGoalSwitch.isOn = false
            createGoalSwitch.onTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    }
    
    
    @IBAction func createGoalAction(_ sender: Any) {
    
        
        if createGoalSwitch.isOn == true {
            let alert = UIAlertController(title: "What is your Goal", message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cnacel", style: .cancel) { (cancel) in
                self.createGoalSwitch.isOn = false
            }
            let action =  UIAlertAction(title: "Submit", style: .default) { (action) in
                self.saveYourGoal()
                self.dismiss(animated: true, completion: nil)
            }
            
            
            alert.addTextField { (textFiled) in
                self.goalText = textFiled
                
            }
            alert.addAction(cancelAction)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func doneBarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changeFontBtn(_ sender: Any) {
        
    }
    
    func saveYourGoal() {
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

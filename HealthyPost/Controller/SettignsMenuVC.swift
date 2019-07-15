//
//  SettignsMenuVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 7/15/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit

class SettignsMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let settingsList = ["Your Goal","Smart Notification","Clear data","Follow on Instagram", "Follow on Facebook", "Follow on Twitter", "Support Developer","Team"]
    let settingsImage = ["goal","notification","data","instagram","facebook","twitter","message","team"]
    
    
    
    
     @IBOutlet weak var homeMenuTableView: UITableView!
     @IBOutlet weak var userSettingsBtn: UIButton!
     @IBOutlet weak var userProfileImage: UIImageView!
     @IBOutlet weak var userNameLbl: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = UserDefaults.standard.object(forKey: "image")  {
            userProfileImage.image = UIImage(data: data as! Data)
        }
        if let userName = UserDefaults.standard.object(forKey: "userName")  {
            userNameLbl.text = userName as? String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

    }
    

    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? SettingsCell else {return  UITableViewCell()}
        cell.settingsLbl.text = settingsList[indexPath.row]
        cell.settingsImage.image = UIImage(named: settingsImage[indexPath.row])
        return cell
    }
  

}

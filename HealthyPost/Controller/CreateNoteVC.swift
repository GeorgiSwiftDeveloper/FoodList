//
//  CreateNoteVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 8/3/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit

class CreateNoteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
//    let descText = UITextField()
    
    let sections = ["Descriiption", "Comment", "Calorie","Time","Is it Healthy ? "]
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
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
            let descText = UITextField(frame: CGRect(x: 0, y: 0, width: 414, height: 70))
            descText.placeholder = "Enter product descriptiion"
            descText.font = UIFont.systemFont(ofSize: 15)
            descText.textAlignment = .center
            //cell.contentView.addSubview(tf)
            cell?.addSubview(descText)
            
            break
        case 1:
            let commentText = UITextField(frame: CGRect(x: 0, y: 0, width: 414, height: 70))
            commentText.placeholder = "Enter product comment here"
            commentText.font = UIFont.systemFont(ofSize: 15)
            commentText.textAlignment = .center
            //cell.contentView.addSubview(tf)
            cell?.addSubview(commentText)

            break
        case 2:
            tableView.rowHeight = 40
            let calorieTxt = UITextField(frame: CGRect(x: 0, y: 0, width: 414, height: 40))
            calorieTxt.placeholder = "ex 200 cl"
            calorieTxt.font = UIFont.systemFont(ofSize: 15)
            calorieTxt.textAlignment = .center
            //cell.contentView.addSubview(tf)
            cell?.addSubview(calorieTxt)

            break
        case 3:
             tableView.rowHeight = 150
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 414, height: 150))
             datePicker.date = Date()
             cell?.addSubview(datePicker)
            break
        case 4:
            tableView.rowHeight = 50
            let items = ["YES" , "NO"]
            let segmentedControl = UISegmentedControl(items : items)
            segmentedControl.center =  self.view.center
            segmentedControl.selectedSegmentIndex = 0
            cell?.addSubview(segmentedControl)
            break
        default:
            break
        }
        return cell!
    }

}

//
//  CreateNoteVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 8/3/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit

class CreateNoteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    let descText = UITextField()
    let commentText = UITextField()
    let calorieTxt = UITextField()
    let datePicker = UIDatePicker()
    let segmentedControl = UISegmentedControl()
    
    let sections = ["Descriiption", "Comment", "Calorie","Time","Is it Healthy ? "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.insertSegment(withTitle: "YES", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "NO", at: 1, animated: true)
      
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
            descText.textAlignment = .center
            //cell.contentView.addSubview(tf)
            cell?.addSubview(descText)
            
            break
        case 1:
            commentText.frame = CGRect(x: 0, y: 0, width: 414, height: 70)
            commentText.placeholder = "Enter product comment here"
            commentText.font = UIFont.systemFont(ofSize: 15)
            commentText.textAlignment = .center
            //cell.contentView.addSubview(tf)
            cell?.addSubview(commentText)

            break
        case 2:
            tableView.rowHeight = 40
            calorieTxt.frame = CGRect(x: 0, y: 0, width: 414, height: 40)
            calorieTxt.placeholder = "ex 200 cl"
            calorieTxt.font = UIFont.systemFont(ofSize: 15)
            calorieTxt.textAlignment = .center
            //cell.contentView.addSubview(tf)
            cell?.addSubview(calorieTxt)

            break
        case 3:
             tableView.rowHeight = 150
             datePicker.frame = CGRect(x: 0, y: 0, width: 414, height: 150)
             datePicker.date = Date()
             cell?.addSubview(datePicker)
            break
        case 4:
            tableView.rowHeight = 50
            segmentedControl.frame = CGRect(x: 135, y: 10, width: 150, height: 30)
            segmentedControl.selectedSegmentIndex = 0
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

}

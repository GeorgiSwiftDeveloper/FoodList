//
//  CalendarVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 4/24/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData


class CalendarVC: UIViewController,UIGestureRecognizerDelegate,FSCalendarDelegate,FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
 

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var todayDateLbl: UILabel!
    
    var healthModel = [HealthModel]()
    var coreDataModel = CoreDataStackClass()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchNotePoste()
        self.calendarTableView.reloadData()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.layer.cornerRadius = 7
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        self.calendar.select(Date())
        self.calendar.scope = .month
        self.calendar.accessibilityIdentifier = "calendar"
        todayDateLbl.text = "\(DateService.service.crrentDateTime())"
    }
    
  
    
    
  
    
    @IBAction func goBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createNoteBtn(_ sender: Any) {
        performSegue(withIdentifier: "CreateNoteVC", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createNoteVC = segue.destination as! CreateandUpdateNoteVC
        createNoteVC.selectedTime = mydate
        print(mydate)
    }
    
 
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
   

    var mydate = Date()
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        todayDateLbl.text = "\(DateService.service.selectedDate(date: date))"
        let selectedDatesa = calendar.selectedDate.map({$0})
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let form = formatter.string(from: selectedDatesa!)
        
        let dateform = DateFormatter()
        dateform.dateFormat = "yyyy/MM/dd"
        let myform = formatter.date(from: form)
        mydate = myform!
        print(mydate)
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        fetchNotePoste()
        calendarTableView.reloadData()
    }
    
//    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        print("\(self.dateFormatter.string(from: calendar.currentPage))")
//    }
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.calendarTableView.contentOffset.y <= -self.calendarTableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            @unknown default:
                break
            }
        }
        return shouldBegin
    }
    
  
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return healthModel.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? CalendareTableViewCell
        cell?.configureCell(post: healthModel[indexPath.row])
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removePostRow(atIndexPath: indexPath)
            healthModel.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

        }
    }
    
    func predicateForDayFromDate(date: NSDate) -> NSPredicate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var components = calendar!.components([.year, .month, .day, .hour, .minute, .second], from: date as Date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar!.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar!.date(from: components)
        
        return NSPredicate(format: "postTime >= %@ AND postTime =< %@", argumentArray: [startDate!, endDate!])
    }
    
    func fetchNotePoste() {
         let managedContext = coreDataModel.persistentContainer.viewContext
        let request = NSFetchRequest<HealthModel>(entityName: "HealthModel")
        request.predicate =  predicateForDayFromDate(date: mydate as NSDate)
        let sectionSortDescriptor = NSSortDescriptor(key: "postTime", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        do {
            healthModel = try managedContext.fetch(request)
            for item in healthModel {
                item.value(forKey: "userComment")
                item.value(forKey: "postTime")
                item.value(forKey: "selectedType")
                item.value(forKey: "brandName")
                item.value(forKey: "calorie")
            }
            
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
    }
    
    func removePostRow(atIndexPath indexPath: IndexPath) {
       let managedContext = coreDataModel.persistentContainer.viewContext
        managedContext.delete(healthModel[indexPath.row])
        do{
            try managedContext.save()
        }catch {
            print("Could not remove post \(error.localizedDescription)")
        }
    }
    
}



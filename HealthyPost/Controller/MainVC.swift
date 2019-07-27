//
//  MainVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 7/15/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//


import UIKit
import CoreData
import FSCalendar
import Charts

class MainVC: UIViewController, ChartViewDelegate {


    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var notePostTableView: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var cardViewHeightLayout: NSLayoutConstraint!
    
    
    
     var healthModelData = [HealthModel]()
     var coreDataModel = CoreDataStackClass()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: appNameLbl.text as! String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 40)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.2471, green: 0.549, blue: 0, alpha: 1.0) , range: NSRange(location:3,length:1))
        appNameLbl.attributedText = myMutableString
        
//        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
//    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
       
        fetchDataByDate()
        updateDataByWeek()
        chartViewDesingFunction()
        notePostTableView.reloadData()
        
//        notePostTableView.estimatedRowHeight = notePostTableView.rowHeight
//        notePostTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchDataByDate()
        updateDataByWeek()
        notePostTableView.reloadData()
        currentDateLabel.text = "\(DateService.service.crrentDateTime())"
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.cardViewHeightLayout.constant = self.notePostTableView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    
    override  func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.cardViewHeightLayout.constant = self.notePostTableView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func chartViewDesingFunction() {
        chartView.delegate = self
        chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: DateService.service.weekDays.shortWeekdaySymbols)
        chartView.xAxis.granularity = 1.0
        chartView.doubleTapToZoomEnabled = false
        
        //Xaxis Label
        let xAxis: XAxis? = chartView.xAxis
        xAxis?.labelPosition = .top
        xAxis?.labelTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        xAxis?.labelFont = UIFont(name: "Helvetica", size: 12)!
        xAxis?.drawGridLinesEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        //Grid
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        
        chartView.maxVisibleCount = 0
        chartView.drawBarShadowEnabled = false
        chartView.legend.enabled = false
        chartView.highlightPerTapEnabled = true
        chartView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        chartView.reloadInputViews()
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {
        print("chartValueSelected : x = \(highlight)")
        
    }
    @IBAction func calendarVCBtn(_ sender: Any) {
       guard let storyboard = storyboard?.instantiateViewController(withIdentifier: "CalendarVC") else {return}
        self.present(storyboard, animated: true, completion: nil)
    }
    
    
    @IBAction func addNoteBtnAction(_ sender: Any) {
        guard let storyboard = storyboard?.instantiateViewController(withIdentifier: "CreateNoteVC") else {return}
        self.present(storyboard, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateMealVC" {
            let destVC = segue.destination as! CreateMealVC
            destVC.health = sender as? HealthModel
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction =  UIContextualAction(style: .normal, title: "Edit", handler: { (action,view,completionHandler ) in
            let healthPost = self.healthModelData[indexPath.row]
            
            self.performSegue(withIdentifier: "CreateMealVC", sender: healthPost)
            completionHandler(true)
        })
        editAction.backgroundColor =  #colorLiteral(red: 0, green: 0.5, blue: 0, alpha: 1)
        
        let deleteAction =  UIContextualAction(style: .normal, title: "Delete", handler: { (action,view,completionHandler ) in
            self.removePostRow(atIndexPath: indexPath)
            self.healthModelData.remove(at: indexPath.row)
            self.notePostTableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateDataByWeek()
            self.chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
            
            DispatchQueue.main.async {
                self.cardViewHeightLayout.constant = self.notePostTableView.contentSize.height
                self.view.layoutIfNeeded()
            }
            completionHandler(true)
        })
        deleteAction.backgroundColor =  #colorLiteral(red: 0.5, green: 0, blue: 0, alpha: 1)
        let confrigation = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        
        return confrigation
    }
    
    
    
    func updateDataByWeek() {
        let managedContext = coreDataModel.persistentContainer.viewContext
        let request = NSFetchRequest<HealthModel>(entityName: "HealthModel")
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .weekday, value: $0 - dayOfWeek, to: today) }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let week =  days.map({ (DateelementOfCollection) -> Date in
            return DateelementOfCollection
        })
        
        let frompredicate = NSPredicate(format: "postTime > %@", week[0]  as CVarArg)
        let topredicate = NSPredicate(format: "postTime  <> %@",  week[6] as CVarArg )
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [frompredicate, topredicate])
        request.predicate = datePredicate
        do{
            let result = try managedContext.fetch(request)
            var aRed = Double()
            var agrean = Double()
            
            var goodArray = [String]()
            var badArray = [String]()
            var index: Int = -1
            var chardtData = [BarChartDataEntry]()
            for mydate in week {
                index += 1
                for getData in result {
                    if formatter.string(from: getData.postTime!) == formatter.string(from: mydate)  {
                        if getData.selectedType == "good"{
                            agrean += 3.0
                        }else if getData.selectedType == "bad" {
                            aRed -= 3.0
                        }
                    }
                }
                
                chardtData.append(BarChartDataEntry(x: Double(index), y: aRed))
                chardtData.append(BarChartDataEntry(x: Double(index), y: agrean))
                aRed = 0.0
                agrean = 0.0
            }
            
            for getData in result {
                if formatter.string(from: getData.postTime!) == formatter.string(from: Date()) {
                    if getData.selectedType == "good"{
                        goodArray.append(getData.selectedType!)
                    }else if getData.selectedType == "bad" {
                        badArray.append(getData.selectedType!)
                    }
                }
            }
            let red = ColorSelection.colorPicker.badType
            let green = ColorSelection.colorPicker.goodType
            let colors = chardtData.map { (entry) -> NSUIColor in
                return entry.y < 0 ? red : green
            }
            let set =
                BarChartDataSet(entries: chardtData, label: "Values")
            set.colors = colors
            set.valueColors = colors
            
            let data = BarChartData(dataSet: set)
            data.setValueFont(.systemFont(ofSize: 10))
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            data.barWidth = 0.3
            chartView.data = data
        }catch let error as NSError{
            print(error.description)
        }
    }
    
    func fetchDataByDate() {
        let managedContext = coreDataModel.persistentContainer.viewContext
        let request = NSFetchRequest<HealthModel>(entityName: "HealthModel")
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        let frompredicate = NSPredicate(format:"postTime > %@", dateFrom as CVarArg)
        let toPredicate = NSPredicate(format: "postTime < %@", dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [frompredicate, toPredicate])
        request.predicate = datePredicate
        
        let sectionSortDescriptor = NSSortDescriptor(key: "postTime", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        do {
            healthModelData = try managedContext.fetch(request)
            for item in healthModelData {
                item.value(forKey: "userComment")
                item.value(forKey: "postTime")
                item.value(forKey: "selectedType")
                item.value(forKey: "brandName")
                item.value(forKey: "calorie")
                
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    func removePostRow(atIndexPath indexPath: IndexPath) {
        let managedContext = coreDataModel.persistentContainer.viewContext
        managedContext.delete(healthModelData[indexPath.row])
        do{
            try managedContext.save()
        }catch {
            print("Could not remove post \(error.localizedDescription)")
        }
    }
    

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthModelData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteHealthCell", for: indexPath) as? NoteTableViewCell else {return UITableViewCell()}
        cell.configureCell(post: healthModelData[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

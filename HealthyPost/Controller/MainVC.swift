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

    
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var notePostTableView: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var cardViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let healthFood = [BestFoodList(imageName: "image1.png", title: "Avocado"),
                                BestFoodList(imageName: "image2.jpg", title: "Bean"),
                                BestFoodList(imageName: "image3.jpg", title: "Chicken"),
                                BestFoodList(imageName: "image4.jpg", title: "Fish"),
                                BestFoodList(imageName: "image.jpg", title: "Broccoli"),
                                BestFoodList(imageName: "image7.jpg", title: "Soup")]
    
     var healthModelData = [HealthModel]()
     var coreDataModel = CoreDataStackClass()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataByDate()
        getChartViewDataFromCoplitionHandler()
        chartViewDesingFunction()
        notePostTableView.reloadData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchDataByDate()
        getChartViewDataFromCoplitionHandler()
        notePostTableView.reloadData()
        currentDateLabel.text = "\(DateService.service.crrentDateTime())"
        DispatchQueue.main.async {
            self.cardViewHeightLayout.constant = self.notePostTableView.contentSize.height
            self.view.layoutIfNeeded()
            
        }
    }
    
    
    override  func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        DispatchQueue.main.async{
            self.cardViewHeightLayout.constant = self.notePostTableView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    func getChartViewDataFromCoplitionHandler() {
        ChartViewModel.getChartViewData.updateDataByWeek { (chartData, error) in
            if let chartData = chartData {
                DispatchQueue.main.async {
                    self.chartView.data = chartData
                }
            }
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
        xAxis?.labelPosition = .bottom
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
        if segue.identifier == "CreateNoteVC" {
            let destVC = segue.destination as! CreateNoteVC
            destVC.healthEditReciver = sender as? HealthModel
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction =  UIContextualAction(style: .normal, title: "Edit", handler: { (action,view,completionHandler ) in
            let healthPost = self.healthModelData[indexPath.row]
            
            self.performSegue(withIdentifier: "CreateNoteVC", sender: healthPost)
            completionHandler(true)
        })
        editAction.backgroundColor =  #colorLiteral(red: 0, green: 0.5, blue: 0, alpha: 1)
        
        let deleteAction =  UIContextualAction(style: .normal, title: "Delete", handler: { (action,view,completionHandler ) in
            self.removePostRow(atIndexPath: indexPath)
            self.healthModelData.remove(at: indexPath.row)
            self.notePostTableView.deleteRows(at: [indexPath], with: .automatic)
            self.getChartViewDataFromCoplitionHandler()
            self.chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
            if self.healthModelData.count == 0 {
                 self.contentViewHeightLayout.constant = 1000
                self.notePostTableView.reloadData()
            }
            DispatchQueue.main.async {
                self.cardViewHeightLayout.constant = self.notePostTableView.contentSize.height
                self.contentViewHeightLayout.constant -= 20
                self.view.layoutIfNeeded()
            }
            completionHandler(true)
        })
        deleteAction.backgroundColor =  #colorLiteral(red: 0.5, green: 0, blue: 0, alpha: 1)
        let confrigation = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        
        return confrigation
    }
    
    
    
    func fetchDataByDate() {
//        let managedContext = coreDataModel.persistentContainer.viewContext
//        let request = NSFetchRequest<HealthModel>(entityName: "HealthModel")
        let request : NSFetchRequest<HealthModel> = HealthModel.fetchRequest()
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
            healthModelData = try (managedContext?.fetch(request))!
            print(healthModelData.count)
            for item in healthModelData {
                item.value(forKey: "userComment")
                item.value(forKey: "postTime")
                item.value(forKey: "selectedType")
                item.value(forKey: "brandName")
                item.value(forKey: "calorie")
                self.contentViewHeightLayout.constant += 15
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    func removePostRow(atIndexPath indexPath: IndexPath) {
//        let managedContext = coreDataModel.persistentContainer.viewContext
        managedContext?.delete(healthModelData[indexPath.row])
        do{
            try managedContext?.save()
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

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return healthFood.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as? ImageCollectionView
        let topFoodList = healthFood[indexPath.row]
        cell?.configureCell(foodList: topFoodList)
        return cell!
    }
    
    
}

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

let managedContexts = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
class MainVC: UIViewController, ChartViewDelegate {

     var emtyLabeltext = UILabel()
    @IBOutlet weak var tableViewCard: CardView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var notePostTableView: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var cardViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var userGoalLbl: UILabel!
    
     var healthModelData = [HealthModel]()
     var userGoal   = [Goal]()
    
     private var coreDataModel = CoreDataStackClass()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ReciveDataBackFromCoreData.getChartViewData.fetchDataFromCoreData { (healthModel, error) in
            if let healthModel = healthModel {
                self.healthModelData = healthModel
                self.chartViewDesingFunction()
                self.getChartViewDataFromCoplitionHandler()
                self.addlabel()
                self.notePostTableView.reloadData()
                self.contentViewHeightLayout.constant  = self.contentViewHeightLayout.constant + self.notePostTableView.contentSize.height
            }
        }
    }

    override  func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        ReciveDataBackFromCoreData.getChartViewData.fetchDataFromCoreData { (healthModel, error) in
            if let healthModel = healthModel {
                self.healthModelData = healthModel
                self.chartViewDesingFunction()
                self.getChartViewDataFromCoplitionHandler()
                self.addlabel()
                self.notePostTableView.reloadData()
            }
            if self.healthModelData.count == 0  {
                self.cardViewHeightLayout.constant = 0
            }else {
                self.contentViewHeightLayout.constant  = self.contentViewHeightLayout.constant + 50
                self.cardViewHeightLayout.constant =   CGFloat(self.healthModelData.count * 65)
            }
        }
    }
    
    

    func addlabel() {
        if healthModelData.count == 0 {
            emtyLabel.text = "Add your daily post here"
            emtyLabel.frame = CGRect(x: 70, y: 300, width: 300, height: 60)
            emtyLabel.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            emtyLabel.font = UIFont(name: "Georgia", size: 20)
            emtyLabel.font = UIFont.boldSystemFont(ofSize: 25)
            emtyLabel.isHidden = false
            contentView.addSubview(emtyLabel)
        }else{
            emtyLabel.isHidden = true
        }
    }
    
    
    //MARK:Get data for  Update ChartView data by week day
    func getChartViewDataFromCoplitionHandler() {
        ReciveDataBackFromCoreData.getChartViewData.updateChartDataByWeekDay { (chartData, error) in
            if let chartData = chartData {
                DispatchQueue.main.async {
                    self.chartView.data = chartData
                }
            }
        }
    }
    
    
    //MARK: Chart View design function 
    func chartViewDesingFunction() {
        chartView.delegate = self
        chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: DateService.service.weekDays.weekdaySymbols)
        chartView.xAxis.granularity = 1.0
        chartView.doubleTapToZoomEnabled = false
        
        //Xaxis Label
        let xAxis: XAxis? = chartView.xAxis
        xAxis?.labelPosition = .bottom
        xAxis?.labelTextColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        xAxis?.labelFont = UIFont(name: "Helvetica", size: 9)!
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
    
    
    
    
//    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
//    {
//        print("chartValueSelected : x = \(highlight)")
//
//    }
    
    
    @IBAction func calendarVCBtn(_ sender: Any) {
       guard let storyboard = storyboard?.instantiateViewController(withIdentifier: "CalendarVC") else {return}
        self.present(storyboard, animated: true, completion: nil)
    }
    

    @IBAction func addNoteBtnAction(_ sender: Any) {
        guard let storyboard = storyboard?.instantiateViewController(withIdentifier: "CreateNoteVC") else {return}
        self.present(storyboard, animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateNote" {
            let destVC = segue.destination as! CreateNoteVC
            destVC.healthEditReciver = sender as? HealthModel

        }
    }
    
    
    //MARK: Delete and Edite UITableView [Indexpath.row]
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction =  UIContextualAction(style: .normal, title: "Edit", handler: { (action,view,completionHandler ) in
            let healthPost = self.healthModelData[indexPath.row]
            self.performSegue(withIdentifier: "CreateNote", sender: healthPost)
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
                 self.contentViewHeightLayout.constant = 800
                self.notePostTableView.reloadData()
            }
            self.addlabel()
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
    
    //MARK: Delete data from Core Data NSManagetObjectContext
    func removePostRow(atIndexPath indexPath: IndexPath) {
        managedContexts?.delete(healthModelData[indexPath.row])
        do{
            try managedContexts?.save()
        }catch {
            print("Could not remove post \(error.localizedDescription)")
        }
    }
    
    
    
    
    

    func fetchGoal() {
         let request : NSFetchRequest<Goal> = Goal.fetchRequest()
        do {
            userGoal = try ((managedContexts?.fetch(request))!)
            for goals in userGoal {
                userGoalLbl.text =  goals.value(forKey: "goalText") as? String
            }
        } catch  {
            print(error.localizedDescription)
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

//
//  TodayViewController.swift
//  Extension
//
//  Created by Georgi Malkhasyan on 5/31/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData
import Charts

class TodayViewController: UIViewController, NCWidgetProviding, ChartViewDelegate {
        
    @IBOutlet weak var chartView: BarChartView!
     var coreDataModel = CoreDataStackClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        fetchWeights()
        chartViewDesingFunction()
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
        xAxis?.labelTextColor = .black
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
        
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        completionHandler(NCUpdateResult.newData)
    }
    
    //Mark: Show more - show less
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize)
    {
        if activeDisplayMode == .expanded
        {
            preferredContentSize = CGSize(width: 0.0, height: 200.0) //Size of the widget you want to show in expanded mode
        }
        else
        {
            preferredContentSize = maxSize
                fetchWeights()
        }
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myAppUrl = NSURL(string: "HealthyPost")!
        extensionContext?.open(myAppUrl as URL, completionHandler: { (success) in
            if (!success) {
                print("error")            }
        })
    }
    
    
    
    
  //  MARK: Fetch data from HealthModel for update Widget Bar Chart
    func fetchWeights() {
          let managedContext = coreDataModel.persistentContainer.viewContext
        let request = NSFetchRequest<HealthModel>(entityName: "HealthModel")
        request.returnsObjectsAsFaults = false
        
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
        do {
            let results = try managedContext.fetch(request)
//            for i in results {
//                print("adassdadada\(i.brandName)")
//            }
            var aRed = Double()
            var agrean = Double()
            var index: Int = -1
            var chardtData = [BarChartDataEntry]()
            for mydate in week {
                index += 1
                for getData in results {
//                    print("\(getData.postTime) useeer")
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
            let red = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 0.8394243673)
            let green = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
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
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}

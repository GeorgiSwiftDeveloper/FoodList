//
//  ChartViewModel.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 7/29/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import Charts
import CoreData



class ReciveDataBackFromCoreData {
    var healthModelData = [HealthModel]()
    var coreDataModel = CoreDataStackClass()

    static let getChartViewData = ReciveDataBackFromCoreData()
    
    
    //MARK: Update chartView by week day
func updateDataByWeek(completionHandler:@escaping (ChartData?, Error?) -> Void){
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
    for i in week  {
        print(i)
    }
    
    let frompredicate = NSPredicate(format: "postTime > %@", week[0]  as CVarArg)
    let topredicate = NSPredicate(format: "postTime  <> %@",  week[6] as CVarArg )
    let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [frompredicate, topredicate])
    request.predicate = datePredicate
    do{
        guard let result = try managedContexts?.fetch(request) else { return  }
        var aRed = Double()
        var agrean = Double()
        
//        var goodArray = [String]()
//        var badArray = [String]()
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
        
//        for getData in result {
//            if formatter.string(from: getData.postTime!) == formatter.string(from: Date()) {
//                if getData.selectedType == "good"{
//                    goodArray.append(getData.selectedType!)
//                }else if getData.selectedType == "bad" {
//                    badArray.append(getData.selectedType!)
//                }
//            }
//        }
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
        completionHandler(data,nil)
    }catch let error as NSError{
        completionHandler(nil, error)
        print(error.description)
    }
    }
    
    
    
    //fetch data form Core Data and display to UITableViewCell
    func fetchDataFromCoreData(completonHandler:@escaping ([HealthModel]?, Error?) -> Void) {
        var healthModel = [HealthModel]()
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
            healthModel = try (managedContexts?.fetch(request))!
            for item in healthModel {
                item.value(forKey: "userComment")
                item.value(forKey: "postTime")
                item.value(forKey: "selectedType")
                item.value(forKey: "brandName")
                item.value(forKey: "calorie")
            }
            completonHandler(healthModel,nil)
        } catch let error as NSError {
            completonHandler(nil,error)
            print(error.description)
        }
    }
}

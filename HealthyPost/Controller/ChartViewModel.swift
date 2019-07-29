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

var healthModelData = [HealthModel]()
var coreDataModel = CoreDataStackClass()

class ChartViewModel {

    static let getChartViewData = ChartViewModel()
    
func updateDataByWeek(completionHandler:@escaping (ChartData?, Error?) -> Void){
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
        completionHandler(data,nil)
    }catch let error as NSError{
        completionHandler(nil, error)
        print(error.description)
    }
    }
}

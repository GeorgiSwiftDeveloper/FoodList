//
//  DateSarvice.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 3/21/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import  UIKit


class DateService {
    static let service = DateService()
    func clearTempFolder() {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
      let weekDays = DateFormatter()
    
    func crrentDateTime() -> String {
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return "\(dateFormatter.string(from: now as Date))"
    }
    
    
    func pickerDate(date: Date) -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return "\(dateFormatter.string(from: date as Date))"
    }
    
    func selectedDate(date: Date) -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return "\(dateFormatter.string(from: date as Date))"
    }

}

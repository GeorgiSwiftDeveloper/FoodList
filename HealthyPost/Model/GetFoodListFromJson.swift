//
//  GetFoodListFromJson.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 8/1/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
import UIKit

//class CallJsonFunction{
//    static let nistance = CallJsonFunction()
//
//
//    func loadUrlInformation() {
//        let urlPath = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/quickAnswer"
//        guard let url = URL(string: urlPath) else {return}
//        let getUrlInformationBack = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if error != nil || data == nil {
//                print("cant find url")
//            }else {
//                do{
//                    guard let getstockJsonFormat = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)  as? [[String: Any]] else {return}
//                    print(getstockJsonFormat)
//                }catch{
//                    print("Cant fnid food Value \(error.localizedDescription)")
//                }
//            }
//        }
//        getUrlInformationBack.resume()
//    }
//}

class BestFoodList {
    var imageName: String?
    var title: String?
    init(imageName: String, title: String) {
        self.imageName = imageName
        self.title = title
    }
}

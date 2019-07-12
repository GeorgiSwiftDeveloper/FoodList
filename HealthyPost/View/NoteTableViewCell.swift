//
//  NoteTableViewCell.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 2/24/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var brandNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var selectedFoodType: UIView!
    @IBOutlet weak var postDate: UILabel!
    
    func configureCell(post: HealthModel) {
        brandNameLbl.text = post.brandName
        descriptionLbl.text = post.userComment
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMM-dd HH:mm"
        postDate.text = dateFormatter.string(from: post.postTime!)
        if post.selectedType == PostType.healthy.rawValue {
           selectedFoodType.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }else if post.selectedType == PostType.notHealthy.rawValue {
             selectedFoodType.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.01176470588, blue: 0.1921568627, alpha: 1)
        }
    }
    
    
 


}

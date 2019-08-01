//
//  ImageCollectionView.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 8/1/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit

class ImageCollectionView: UICollectionViewCell {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodTitleLbl: UILabel!
    
    
    func configureCell(foodList: BestFoodList ) {
        foodImage.image =  UIImage(named: foodList.imageName!)
        foodTitleLbl.text = foodList.title
        
    }
}

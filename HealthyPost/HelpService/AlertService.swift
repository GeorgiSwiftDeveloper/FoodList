//
//  AlertService.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 8/8/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import Foundation
class AlertService {
    
    static var alert = AlertService()
    
    func alert(message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        return alert
    }
}

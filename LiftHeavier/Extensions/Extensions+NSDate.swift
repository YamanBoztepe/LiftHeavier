//
//  Extensions+NSDate.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 11.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

extension NSDate {
    
    func getDate() -> String {
        
        let calender = Calendar.current
        
        let day = calender.component(.day, from: self as Date)
        let month = calender.component(.month, from: self as Date)
        let year = calender.component(.year, from: self as Date)
        
        return "\(day)/\(month)/\(year)"
    }
}

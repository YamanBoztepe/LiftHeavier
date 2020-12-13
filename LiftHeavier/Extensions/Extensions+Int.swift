//
//  Extensions+Int.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 10.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import Foundation

extension Int {
    
    func translateSecondToDuration() -> String {
        let hour = self / 3600
        let minute = (self % 3600) / 60
        let second = (self % 3600) % 60
        
        if second < 0 {
            return "00:00:00"
        } else {
            if hour == 0 {
                return String(format: "%02d:%02d", minute,second)
            } else {
                return String(format: "%02d:%02d%02d", hour,minute,second)
            }
        }
    }
    
    func translateIntToSecond() -> Double {
        let hour = self / 3600
        let minute = (self % 3600) / 60
        let second = (self % 3600) % 60
        
        if second < 0 {
            return 0.0
        } else {
            if hour == 0 {
                return Double(String(format: "%02d.%02d", minute,second)) ?? -1
            } else {
                return Double(String(format: "%02d.%02d%02d", hour,minute,second)) ?? -2
            }
        }
    }
}

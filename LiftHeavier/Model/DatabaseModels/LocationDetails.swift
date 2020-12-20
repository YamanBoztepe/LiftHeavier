//
//  LocationDetails.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 19.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class LocationDetails: Object {
    
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}

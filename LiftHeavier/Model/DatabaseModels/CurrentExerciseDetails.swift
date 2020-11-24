//
//  CurrentExerciseDetails.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 1.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentExerciseDetails : Object {
    
    @objc dynamic var numberOfSet : Int = 1
    @objc dynamic var liftedWeight : Int = 10
    @objc dynamic var reps : Int = 10
    @objc dynamic var date : String = "9999/99/99 99:99"
}


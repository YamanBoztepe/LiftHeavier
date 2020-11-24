//
//  ExerciseDetails.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 30.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class ExerciseDetails : Object {
    
    @objc dynamic var numberOfSet : Int = 1
    @objc dynamic var liftedWeight : Int = 10
    @objc dynamic var reps : Int = 10
    @objc dynamic var oneRM : Double = 1
    var exerciseDetailsMod = LinkingObjects(fromType: ExerciseDate.self, property: "exerciseDetails")
}

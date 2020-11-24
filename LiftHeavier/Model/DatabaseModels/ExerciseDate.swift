//
//  ExerciseDate.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 31.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class ExerciseDate : Object {
    
    @objc dynamic var date : String = "9999/99/99 99:99"
    let exerciseInfoMod = LinkingObjects(fromType: ExerciseInfoModel.self, property: "exerciseDateList")
    let exerciseDetails = List<ExerciseDetails>()
}

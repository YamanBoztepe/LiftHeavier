//
//  PersonalDetails.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 12.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class PersonalDetails: Object {
    
    @objc dynamic var isMale = true
    @objc dynamic var age = -1
    @objc dynamic var height: Double = -1
    @objc dynamic var weight: Double = -1
    
    convenience init(isMale: Bool, age: Int, height: Double, weight: Double) {
        self.init()
        self.isMale = isMale
        self.age = age
        self.height = height
        self.weight = weight
    }
    
    static func addPersonalDetails(isMale: Bool, age: Int, height: Double, weight: Double) {
        
        let currentDetails = PersonalDetails(isMale: isMale, age: age, height: height, weight: weight)
        let realm = try! Realm()
        
        let personalDetails = realm.objects(PersonalDetails.self)
        
        do {
            try realm.write {
                
                if personalDetails.count == 0 {
                    realm.add(currentDetails)
                } else {
                    guard let details = personalDetails.first else { return }
                    details.isMale = isMale
                    details.age = age
                    details.height = height
                    details.weight = weight
                }
                print(realm.objects(PersonalDetails.self))
            }
        } catch {
            print("Error when try to add personal details into the realm: \(error.localizedDescription)")
        }
        
    }
}

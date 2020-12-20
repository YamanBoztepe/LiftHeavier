//
//  UpdateDetailsController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 14.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class UpdateDetailsController: PersonalDetailsController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func setLayout() {
        super.setLayout()
        lblInfoText.removeFromSuperview()
        _ = registerView.anchor(top: topView.bottomAnchor, bottom: savebutton.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: view.frame.width/30, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func loadData() {
        
        guard let personalData = realm.objects(PersonalDetails.self).first else { return }
        
        if personalData.isMale {
            registerView.maleButton.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
            registerView.femaleButton.backgroundColor = .clear
        } else {
            registerView.femaleButton.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
            registerView.maleButton.backgroundColor = .clear
        }
        
        registerView.ageTextField.text = "\(personalData.age)"
        registerView.heightTextField.text = String(format: "%.2f", personalData.height)
        registerView.weightTextField.text = String(format: "%.2f", personalData.weight)
    }
}

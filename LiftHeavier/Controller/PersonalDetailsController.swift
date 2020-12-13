//
//  PersonalDetailsController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 12.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class PersonalDetailsController: UIViewController {
    
    fileprivate let extraView = UIView()
    fileprivate let topView = TopViewWithBackButton()
    
    fileprivate let registerView = RegisterView()
    fileprivate let savebutton = CustomSaveButton()
    
    fileprivate var isMale = true
    fileprivate var isKg = true
    fileprivate var isCm = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        view.keyboardShowObserver()
    }
    
    fileprivate func setLayout() {
        
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        
        [extraView,topView,registerView,savebutton].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/15))
        _ = registerView.anchor(top: topView.bottomAnchor, bottom: savebutton.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = savebutton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: nil,padding: .init(top: 0, left: 0, bottom: view.frame.height/50, right: 0),size: .init(width: view.frame.width/2.5, height: view.frame.height/20))
        
        savebutton.positionInCenterSuperView(centerX: view.centerXAnchor, centerY: nil)
        
        topView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        registerView.kgButton.addTarget(self, action: #selector(kgButtonPressed), for: .touchUpInside)
        registerView.lbsButton.addTarget(self, action: #selector(lbsButtonPressed), for: .touchUpInside)
        registerView.ftButton.addTarget(self, action: #selector(ftButtonPressed), for: .touchUpInside)
        registerView.cmButton.addTarget(self, action: #selector(cmButtonPressed), for: .touchUpInside)
        registerView.maleButton.addTarget(self, action: #selector(maleButtonPressed), for: .touchUpInside)
        registerView.femaleButton.addTarget(self, action: #selector(femaleButtonPressed), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        view.addGestureRecognizer(tapGesture)
        
        savebutton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    
    @objc fileprivate func kgButtonPressed() {
        isKg = true
        registerView.kgButton.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        registerView.lbsButton.backgroundColor = .clear
    }
    @objc fileprivate func lbsButtonPressed() {
        isKg = false
        registerView.kgButton.backgroundColor = .clear
        registerView.lbsButton.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
    }
    @objc fileprivate func cmButtonPressed() {
        isCm = true
        registerView.cmButton.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        registerView.ftButton.backgroundColor = .clear
        registerView.heightTextField.isHidden = false
        registerView.ftTextField.isHidden = true
        registerView.inchTextField.isHidden = true
    }
    @objc fileprivate func ftButtonPressed() {
        isCm = false
        registerView.cmButton.backgroundColor = .clear
        registerView.ftButton.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        registerView.heightTextField.isHidden = true
        registerView.ftTextField.isHidden = false
        registerView.inchTextField.isHidden = false
    }
    @objc fileprivate func maleButtonPressed() {
        isMale = true
        registerView.maleButton.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        registerView.femaleButton.backgroundColor = .clear
    }
    @objc fileprivate func femaleButtonPressed() {
        isMale = false
        registerView.maleButton.backgroundColor = .clear
        registerView.femaleButton.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
    }
    
    @objc fileprivate func backButtonPressed() {
        navigationController?.view.layer.add(CATransition().fromRightToLeft(), forKey: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func keyboardDismiss() {
        self.view.endEditing(true)
    }
    
    @objc fileprivate func saveButtonPressed() {
        
        var isTextEmpty = false
        var age = 0
        var height: Double = 0
        var weight: Double = 0
        
        if registerView.ageTextField.text?.count ?? 0 > 0 {
            registerView.ageTextField.backgroundColor = .white
            age = Int(registerView.ageTextField.text!)!
        } else {
            registerView.ageTextField.backgroundColor = .red
            isTextEmpty = true
        }
        
        if registerView.weightTextField.text?.count ?? 0 > 0 {
            registerView.weightTextField.backgroundColor = .white
            weight = Double(registerView.weightTextField.text!)!
        } else {
            registerView.weightTextField.backgroundColor = .red
            isTextEmpty = true
        }
        
        if isCm {
            if registerView.heightTextField.text?.count ?? 0 > 0 {
                registerView.heightTextField.backgroundColor = .white
                height = Double(registerView.heightTextField.text!)!
            } else {
                registerView.heightTextField.backgroundColor = .red
                isTextEmpty = true
            }
            
        } else {
            if registerView.ftTextField.text?.count ?? 0 > 0 {
                registerView.ftTextField.backgroundColor = .white
                if registerView.inchTextField.text?.count ?? 0 > 0 {
                    height = Double(registerView.ftTextField.text! + "." + registerView.inchTextField.text!)!
                    registerView.inchTextField.backgroundColor = .white
                } else {
                    registerView.inchTextField.backgroundColor = .red
                    isTextEmpty = true
                }
            } else {
                registerView.ftTextField.backgroundColor = .red
                isTextEmpty = true
                if registerView.inchTextField.text?.count ?? 0 > 0 {
                    height = Double(registerView.ftTextField.text! + "." + registerView.inchTextField.text!)!
                    registerView.inchTextField.backgroundColor = .white
                } else {
                    registerView.inchTextField.backgroundColor = .red
                    isTextEmpty = true
                }
            }
        }
        
        if isTextEmpty {
            return
        } else {
            
            if !isKg {
                weight *= 0.45359237
            }
            if !isCm {
                height *= 30.48
            }
            
            PersonalDetails.addPersonalDetails(isMale: isMale, age: age, height: height, weight: weight)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}

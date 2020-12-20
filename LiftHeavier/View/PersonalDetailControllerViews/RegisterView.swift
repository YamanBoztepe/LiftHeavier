//
//  RegisterView.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 12.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class RegisterView: UIView {
    
    fileprivate let genderSection: CustomSectionLabel = {
        let csl = CustomSectionLabel()
        csl.sectionName.text = GENDER
        return csl
    }()
    
    let maleButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(MALE, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        return btn
    }()
    
    let femaleButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(FEMALE, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    fileprivate let buttonStackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    fileprivate let genderStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 25
        return sv
    }()
    
    fileprivate let ageSection: CustomSectionLabel = {
        let age = CustomSectionLabel()
        age.sectionName.text = AGE
        return age
    }()
    
    let ageTextField: TextFieldInsets = {
       let txt = TextFieldInsets()
        txt.placeholder = AGE_PLACEHOLDER
        txt.keyboardType = .numberPad
        return txt
    }()
    
    fileprivate let ageStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 25
        return sv
    }()
    
    fileprivate let heightSection: CustomSectionLabel = {
        let age = CustomSectionLabel()
        age.sectionName.text = HEIGHT
        return age
    }()
    
    let heightTextField: TextFieldInsets = {
       let txt = TextFieldInsets()
        txt.placeholder = HEIGHT_PLACEHOLDER
        txt.keyboardType = .numberPad
        return txt
    }()
    
    let ftTextField: UITextField = {
        let txt = TextFieldInsets()
        txt.placeholder = FT_BUTTON
        txt.keyboardType = .numberPad
        return txt
    }()
    let inchTextField: UITextField = {
        let txt = TextFieldInsets()
        txt.placeholder = INCHES
        txt.keyboardType = .numberPad
        return txt
    }()
    
    let cmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(CM_BUTTON, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        return btn
    }()
    
    let ftButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(FT_BUTTON, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    fileprivate let heightButtonStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    fileprivate let bottomHeightStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 10
        return sv
    }()
    
    fileprivate let heightStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 25
        return sv
    }()
    
    
    fileprivate let weightSection: CustomSectionLabel = {
        let age = CustomSectionLabel()
        age.sectionName.text = WEIGHT
        return age
    }()
    
    let weightTextField: TextFieldInsets = {
       let txt = TextFieldInsets()
        txt.placeholder = WEIGHT_PLACEHOLDER
        txt.keyboardType = .numberPad
        return txt
    }()
    
    let kgButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(KG_BUTTON, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        return btn
    }()
    
    let lbsButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(LBS_BUTTON, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    fileprivate let weightButtonStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    fileprivate let bottomWeightStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 10
        return sv
    }()
    
    fileprivate let weightStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 25
        return sv
    }()
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    fileprivate func setLayout() {
        
        [genderSection,buttonStackView].forEach { genderStackView.addArrangedSubview($0) }
        [maleButton,femaleButton].forEach { buttonStackView.addArrangedSubview($0) }
        
        [ageSection,ageTextField].forEach { ageStackView.addArrangedSubview($0) }
        
        [cmButton,ftButton].forEach { heightButtonStackView.addArrangedSubview($0) }
        [ftTextField,inchTextField,heightTextField,heightButtonStackView].forEach { bottomHeightStackView.addArrangedSubview($0) }
        [heightSection,bottomHeightStackView].forEach { heightStackView.addArrangedSubview($0) }
        
        [kgButton,lbsButton].forEach { weightButtonStackView.addArrangedSubview($0) }
        [weightTextField,weightButtonStackView].forEach { bottomWeightStackView.addArrangedSubview($0) }
        [weightSection,bottomWeightStackView].forEach { weightStackView.addArrangedSubview($0) }
        
        [genderStackView,ageStackView,heightStackView,weightStackView].forEach { addSubview($0) }
        
        ftTextField.isHidden = true
        inchTextField.isHidden = true
        
        _ = genderStackView.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor,padding: .init(top: frame.height/40, left: frame.height/50, bottom: 0, right: frame.height/50),size: .init(width: 0, height: frame.height/5.5))
        _ = ageStackView.anchor(top: genderStackView.bottomAnchor, bottom: nil, leading: genderStackView.leadingAnchor, trailing: genderStackView.trailingAnchor,padding: .init(top: frame.height/40, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: frame.height/5.5))
        _ = heightStackView.anchor(top: ageStackView.bottomAnchor, bottom: nil, leading: genderStackView.leadingAnchor, trailing: genderStackView.trailingAnchor,padding: .init(top: frame.height/40, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: frame.height/5.5))
        _ = weightStackView.anchor(top: heightStackView.bottomAnchor, bottom: nil, leading: genderStackView.leadingAnchor, trailing: genderStackView.trailingAnchor,padding: .init(top: frame.height/40, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: frame.height/5.5))
        
        [maleButton,femaleButton,cmButton,ftButton,kgButton,lbsButton].forEach { $0.layer.cornerRadius = frame.width/30;$0.clipsToBounds = true }
        
        [heightTextField,weightTextField,ageTextField,ftTextField,inchTextField].forEach { $0.font = UIFont.systemFont(ofSize: frame.width/30);$0.attributedPlaceholder = NSAttributedString(string: $0.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]) }
    }
}

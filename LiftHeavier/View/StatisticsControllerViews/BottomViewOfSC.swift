//
//  BottomViewOfSC.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 8.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class BottomViewOfSC: UIView {
    
    let mainViewButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "grayDumbbell")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let statisticsViewButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "whiteChart")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.isEnabled = false
        return btn
    }()
    
    let bottomStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        setLayout()
    }
    
    
    
    fileprivate func setLayout() {
        [mainViewButton,statisticsViewButton].forEach { bottomStackView.addArrangedSubview($0) }
        addSubview(bottomStackView)
        _ = bottomStackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

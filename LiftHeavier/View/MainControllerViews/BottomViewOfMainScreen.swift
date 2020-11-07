//
//  BottomViewOfMainScreen.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 16.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class BottomViewMC : UIView {
    
    let mainViewButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "dumbell")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.isEnabled = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        setLayout()
    }
    
    
    
    fileprivate func setLayout() {
        addSubview(mainViewButton)
        mainViewButton.positionInCenterSuperView(centerX: centerXAnchor, centerY: centerYAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

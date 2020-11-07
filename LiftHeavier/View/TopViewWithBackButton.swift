//
//  TopViewWithBackButton.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 18.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class TopViewWithBackButton : UIView {
    
     let backButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    fileprivate let lblText : UILabel = {
        
        let lbl = UILabel()
        lbl.text = TOPVIEW_TITLE
        lbl.textColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    fileprivate func setLayout() {
        addSubview(backButton)
        addSubview(lblText)
        backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        _ = backButton.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil,padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        backButton.positionInCenterSuperView(centerX: nil, centerY: centerYAnchor)
        lblText.positionInCenterSuperView(centerX: centerXAnchor, centerY: centerYAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

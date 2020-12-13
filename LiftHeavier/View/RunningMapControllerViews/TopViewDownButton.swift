//
//  TopViewDownButton.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 25.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class TopViewDownButton: UIView {
    
     let backButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "downButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    fileprivate let lblText : UILabel = {
        
        let lbl = UILabel()
        lbl.text = TOPVIEW_TITLE
        lbl.textColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        return lbl
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    func setLayout() {
        addSubview(backButton)
        addSubview(lblText)
        backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        _ = backButton.anchor(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: frame.width/40))
        backButton.positionInCenterSuperView(size: .init(width: frame.width/13, height: frame.width/13),centerX: nil, centerY: centerYAnchor)
        lblText.positionInCenterSuperView(centerX: centerXAnchor, centerY: centerYAnchor)
        lblText.font = UIFont.boldSystemFont(ofSize: frame.width/20)
    }
    
}

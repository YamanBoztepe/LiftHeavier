//
//  TopViewOfMainScreen.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 16.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class TopViewMC : UIView {
    
    
    let addButton : UIButton = {
       
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plusIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        return btn
    }()
    
    let editButton : UIButton = {
       
        let btn = UIButton(type: .system)
        btn.backgroundColor = .clear
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.rgb(red: 192, green: 192, blue: 192).cgColor
        btn.setTitle("Edit", for: .normal)
        btn.setTitleColor(UIColor.rgb(red: 192, green: 192, blue: 192), for: .normal)
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
        
        backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        
        [lblText,editButton,addButton].forEach({ addSubview($0) })
        
        _ = addButton.anchor(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 5),size: .init(width: 35, height: 35))
        _ = editButton.anchor(top: nil, bottom: nil, leading: nil, trailing: addButton.leadingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 5),size: .init(width: 45, height: 30))
         
        addButton.positionInCenterSuperView(centerX: nil, centerY: centerYAnchor)
        editButton.positionInCenterSuperView(centerX: nil, centerY: centerYAnchor)
        
        lblText.positionInCenterSuperView(centerX: centerXAnchor, centerY: centerYAnchor)
        
        editButton.layer.cornerRadius = 5
        addButton.layer.cornerRadius = 35 / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

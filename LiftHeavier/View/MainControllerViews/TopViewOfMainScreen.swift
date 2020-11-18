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
        return lbl
    }()
    
    let runningViewButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "RunningGray")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    fileprivate func setLayout() {
        
        backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        
        [runningViewButton,lblText,editButton,addButton].forEach({ addSubview($0) })
        
        _ = addButton.anchor(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: frame.width/40),size: .init(width: frame.width/12, height: frame.height/1.3))
        _ = editButton.anchor(top: nil, bottom: nil, leading: nil, trailing: addButton.leadingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: frame.width/40),size: .init(width: frame.width/8, height: frame.height/1.5))
        _ = runningViewButton.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil,padding: .init(top: 0, left: frame.width/40, bottom: 0, right: 0),size: .init(width: frame.width/12, height: frame.height/1.2))
         
        addButton.positionInCenterSuperView(centerX: nil, centerY: centerYAnchor)
        editButton.positionInCenterSuperView(centerX: nil, centerY: centerYAnchor)
        runningViewButton.positionInCenterSuperView(centerX: nil, centerY: centerYAnchor)
        
        lblText.positionInCenterSuperView(centerX: centerXAnchor, centerY: centerYAnchor)
        lblText.font = UIFont.boldSystemFont(ofSize: frame.width/20)
        
        editButton.layer.cornerRadius = 5
        addButton.layer.cornerRadius = 35 / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

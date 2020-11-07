//
//  TopViewADC.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 24.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit


class TopViewADC : UIView {
    
    fileprivate let lblText : UILabel = {
        
        let lbl = UILabel()
        lbl.text = TOPVIEW_TITLE
        lbl.textColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()
    
    let addButton : UIButton = {
       
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plusIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        return btn
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setLayout() {
        
        backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        [lblText,addButton].forEach { addSubview($0) }
        
        _ = addButton.anchor(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 5),size: .init(width: 30, height: 30))
        
        lblText.positionInCenterSuperView(centerX: centerXAnchor, centerY: centerYAnchor)
        addButton.positionInCenterSuperView(centerX: nil, centerY: centerYAnchor)
    }
}

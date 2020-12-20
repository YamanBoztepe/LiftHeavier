//
//  TopViewOfRC.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 17.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class TopViewOfRC: UIView {
    
    fileprivate let lblText : UILabel = {
        let lbl = UILabel()
        lbl.text = TOPVIEW_TITLE
        lbl.textColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        return lbl
    }()
    
    let personalDetailButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "person")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let backButton : UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "forwardButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        
        [personalDetailButton,lblText,backButton].forEach { addSubview($0) }
        
        _ = personalDetailButton.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil,padding: .init(top: 0, left: frame.width/30, bottom: 0, right: 0))
        personalDetailButton.positionInCenterSuperView(centerX: nil, centerY: centerYAnchor)
        _ = backButton.anchor(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: frame.width/30))
        backButton.positionInCenterSuperView(size: .init(width: frame.width/20, height: frame.height/2), centerX: nil, centerY: centerYAnchor)
        
        lblText.positionInCenterSuperView(centerX: centerXAnchor, centerY: centerYAnchor)
        lblText.font = UIFont.boldSystemFont(ofSize: frame.width/20)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

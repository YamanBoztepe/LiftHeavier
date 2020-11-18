//
//  TopViewOfSC.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 8.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class TopViewOfSC: UIView {
    
    fileprivate let lblText : UILabel = {
        
        let lbl = UILabel()
        lbl.text = TOPVIEW_TITLE
        lbl.textColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        lblText.font = UIFont.boldSystemFont(ofSize: frame.width/20)
    }
    
    fileprivate func setLayout() {
        
        backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        addSubview(lblText)
        lblText.positionInCenterSuperView(centerX: centerXAnchor, centerY: centerYAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

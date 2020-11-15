//
//  ExerciseStatisticCell.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 9.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class ExerciseStatisticCell: UICollectionViewCell {
    
    let lblText : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    fileprivate func setLayout() {
        
        layer.cornerRadius = frame.width/10
        clipsToBounds = true
        backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        addSubview(lblText)
        _ = lblText.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: frame.width/25, bottom: 0, right: frame.width/25))
        lblText.positionInCenterSuperView(centerX: nil, centerY: centerYAnchor)
        lblText.font = UIFont.boldSystemFont(ofSize: frame.width/16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  WorkoutCell.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 18.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class WorkoutCell: UICollectionViewCell {
    
    static let CELL_IDENTIFIER = "cell"
    
    let lblName : UILabel = {
        let name = UILabel()
        name.text = "Monday" // max 21 character
        name.textColor = .white
        name.numberOfLines = 0
        return name
    }()
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    let deleteIcon : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "delete")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.setShadow(opacity: 1, radius: 5, offSet: .init(width: 0, height: 5), color: .black)
        btn.isHidden = true
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    fileprivate func setLayout() {
        [lblName,deleteIcon].forEach { addSubview($0) }
        setGradientLayer()
        clipsToBounds = true
        
        _ = lblName.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil,padding: .init(top: 0, left: 7, bottom: 7, right: 0),size: .init(width: frame.width-5, height: 0))
        _ = deleteIcon.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil,padding: .init(top: 5, left: 5, bottom: 0, right: 0))
        
        deleteIcon.setRotationAnimation()
        lblName.heightAnchor.constraint(lessThanOrEqualToConstant: frame.height/1.5).isActive = true
        lblName.font = UIFont.boldSystemFont(ofSize: frame.width/8)
        layer.cornerRadius = frame.width/13
        
    }
    
    fileprivate func setGradientLayer() {
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.4,1.2]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


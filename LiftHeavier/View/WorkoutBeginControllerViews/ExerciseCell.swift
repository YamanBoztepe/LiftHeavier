//
//  ExerciseCell.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 26.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class ExerciseCell: UICollectionViewCell {
    
    static let CELL_IDENTIFIER : String = "ExerciseCell"
    
    fileprivate let lblName : UILabel = {
       let lbl = UILabel()
        lbl.text = EXERCISECELL_NAME
        lbl.textColor = .white
        lbl.setShadow(opacity: 1, radius: 5, offSet: .init(width: 3, height: 3), color: .black)
        return lbl
    }()
    
    let lblNameText : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.setShadow(opacity: 1, radius: 1, offSet: .init(width: 1, height: 1), color: .black)
        return lbl
    }()
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setGradientLayer()
    }
    
    
    fileprivate func setLayout() {
        lblNameText.text = ""
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        [lblName,lblNameText].forEach { addSubview($0) }
        
        _ = lblName.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil,padding: .init(top: 5, left: 5, bottom: 0, right: 0))
        _ = lblNameText.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil,padding: .init(top: 0, left: 5, bottom: 5, right: 0),size: .init(width: frame.width-5, height: 0))
        
        lblNameText.heightAnchor.constraint(lessThanOrEqualToConstant: frame.height/1.3).isActive = true
        
        lblName.font = UIFont.boldSystemFont(ofSize: frame.size.width/8)
        lblNameText.font = UIFont.boldSystemFont(ofSize: frame.size.width/8)
        layer.cornerRadius = frame.width/13
    }
    
    fileprivate func setGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.4,1.3]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

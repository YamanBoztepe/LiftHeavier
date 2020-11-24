//
//  WorkoutInfoCell.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 18.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class WorkoutInfoCell: UITableViewCell {
    
    static let IDENTIFIER = "WorkoutInfoCell"
    
    var numberOfSet = 0 {
        didSet {
            let mutableAttrText = NSMutableAttributedString(string: "\(SET): ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray.cgColor])
            let attrText = NSMutableAttributedString(string: "\n\(numberOfSet)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            mutableAttrText.append(attrText)
            lblSet.attributedText = mutableAttrText
        }
    }
    var liftedWeight = 0 {
        didSet {
            let mutableAttrText = NSMutableAttributedString(string: "\(WEIGHT_LIFTED): ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray.cgColor])
            let attrText = NSAttributedString(string: "\(liftedWeight)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.cgColor])
            mutableAttrText.append(attrText)
            lblLiftedWeight.attributedText = mutableAttrText
        }
    }
    var reps = 0 {
        didSet {
            let mutableAttrText = NSMutableAttributedString(string: "\(NUMBEROF_REPS): ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray.cgColor])
            let attrText = NSAttributedString(string: "\(reps)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.cgColor])
            mutableAttrText.append(attrText)
            lblReps.attributedText = mutableAttrText
        }
    }
    
    fileprivate let lblSet : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    fileprivate let lblLiftedWeight : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    fileprivate let lblReps : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    fileprivate let weightAndRepsSV : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .leading
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    fileprivate func setLayout() {
        backgroundColor = .clear
        selectionStyle = .none
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        
        [lblLiftedWeight,lblReps].forEach { weightAndRepsSV.addArrangedSubview($0) }
        [lblSet,weightAndRepsSV].forEach { addSubview($0) }
        _ = lblSet.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil,size: .init(width: frame.width/3, height: 0))
        _ = weightAndRepsSV.anchor(top: topAnchor, bottom: bottomAnchor, leading: lblSet.trailingAnchor, trailing: trailingAnchor)
      
        [lblSet,lblLiftedWeight,lblReps].forEach { $0.font = UIFont.systemFont(ofSize: frame.width/15) }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

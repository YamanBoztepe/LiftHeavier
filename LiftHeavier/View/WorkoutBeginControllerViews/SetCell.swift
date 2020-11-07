//
//  SetCell.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 27.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class SetCell: UITableViewCell {

    static let CELL_IDENTIFIER = "SetCell"
    
    var numberOfSet = Int() {
        didSet {
            lblNumberOfSet.text = SET + "\n\(numberOfSet)"
        }
    }
    
    fileprivate let lblNumberOfSet : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    fileprivate let weightLifted : UILabel = {
        let lbl = UILabel()
        lbl.text = WEIGHT_LIFTED
        lbl.textColor = .white
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let weightLiftedTextField : TextFieldInsets = {
        let txt = TextFieldInsets()
        txt.keyboardType = .numberPad
        return txt
    }()
    
    fileprivate let topStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .center
        return sv
    }()
    
    
    fileprivate let repNumber : UILabel = {
        let lbl = UILabel()
        lbl.text = NUMBEROF_REPS
        lbl.textColor = .white
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let repNumberTextField : TextFieldInsets = {
        let txt = TextFieldInsets()
        txt.keyboardType = .numberPad
        return txt
    }()
    
    fileprivate let bottomStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .center
        return sv
    }()
    
    fileprivate let totalStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        return sv
    }()
    
    let percentageStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        return sv
    }()
    
    var arrowImage : UIImageView = {
        let img = UIImageView(image: UIImage(named: "upArrow")!.withRenderingMode(.alwaysOriginal))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let percentageOfChange : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .green
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var amounfOfChange : Int? {
        didSet {
            percentageOfChange.text = "%\(amounfOfChange ?? -1)"
        }
    }
    
    let addButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "addIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    
    fileprivate func setLayout() {
        backgroundColor = .clear
        selectionStyle = .none
        
        [topStackView,bottomStackView].forEach { totalStackView.addArrangedSubview($0) }
        [weightLifted,weightLiftedTextField].forEach { topStackView.addArrangedSubview($0) }
        [repNumber,repNumberTextField].forEach { bottomStackView.addArrangedSubview($0) }
        [arrowImage,percentageOfChange].forEach { percentageStackView.addArrangedSubview($0) }
        [lblNumberOfSet,totalStackView,percentageStackView,addButton].forEach { addSubview($0) }
        
        _ = lblNumberOfSet.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil,size: .init(width: frame.width/10, height: 0))
        
        _ = totalStackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: lblNumberOfSet.trailingAnchor, trailing: percentageStackView.leadingAnchor,padding: .init(top: 0, left: frame.width/30, bottom: 0, right: frame.width/30))
        _ = percentageStackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: frame.width/30),size: .init(width: frame.width/4.5, height: 0))
        _ = addButton.anchor(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor,size: .init(width: frame.width/5, height: frame.width/5))
        addButton.positionInCenterSuperView(centerX: nil, centerY: centerYAnchor)
        
        arrowImage.frame.size = percentageOfChange.frame.size
        [lblNumberOfSet,weightLifted,repNumber].forEach { $0.font = UIFont.boldSystemFont(ofSize: frame.width/25) }
        percentageOfChange.font = UIFont.boldSystemFont(ofSize: frame.width/20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

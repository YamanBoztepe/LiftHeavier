//
//  AddWorkoutController.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 18.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class WindowSettingsController: UIViewController {
    
    fileprivate let topView = TopViewWithBackButton()
    let extraView = UIView()
    
    fileprivate let sectionLabel1 : CustomSectionLabel = {
        let cstm = CustomSectionLabel()
        cstm.sectionName.text = WINDOW_SETTINGS
        return cstm
    }()
    
    fileprivate let windowSettings = WindowSettingsView()
    
    fileprivate let sectionLabel2 : CustomSectionLabel = {
        let cstm = CustomSectionLabel()
        cstm.sectionName.text = WINDOW_VIEW
        return cstm
    }()
    
    fileprivate let nextButton = CustomSaveButton()
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    let realm = try! Realm()
    
    
    var windowText : String = "" {
        didSet {
            collectionView.reloadData()
        }
    }
    var windorColor : UIColor = .blue {
        didSet {
            collectionView.reloadData()
        }
    }
    var windowColorText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        setLayout()
        setTargetToButtons()
        setGestureRecognizer()
        
        windowSettings.txtField.delegate = self
        collectionView.dataSource = self
        
        view.keyboardShowObserverForWSC()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    fileprivate func setLayout() {
        
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        collectionView.backgroundColor = .clear
        nextButton.buttonTitle.text = WINDOWBUTTON_TEXT
        nextButton.isEnabled = false
        
        [extraView,topView,sectionLabel1,windowSettings,sectionLabel2,collectionView,nextButton].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/20))
        
        
        _ = sectionLabel1.anchor(top: topView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: 10, left: 5, bottom: 0, right: 5),size: .init(width: 0, height: view.frame.height/20))
        _ = windowSettings.anchor(top: sectionLabel1.bottomAnchor, bottom: sectionLabel2.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/4))
        
        _ = sectionLabel2.anchor(top: windowSettings.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/20))
        
        _ = collectionView.anchor(top: sectionLabel2.bottomAnchor, bottom: nextButton.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        _ = nextButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: nil,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: view.frame.width/2.5, height: view.frame.height/20))
        
        nextButton.positionInCenterSuperView(centerX: view.centerXAnchor, centerY: nil)
    }
    
    fileprivate func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    fileprivate func setTargetToButtons() {
        topView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        windowSettings.btnList.forEach { $0.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)}
    }
    
    fileprivate func setCollectionView() {
        let layout : UICollectionViewFlowLayout = {
            let lyt = UICollectionViewFlowLayout()
            lyt.itemSize = CGSize(width: view.frame.width / 1.6 , height: view.frame.height / 4)
            lyt.sectionInset = UIEdgeInsets(top: lyt.itemSize.height/3, left: lyt.itemSize.width/10, bottom: 0, right: 0)
            return lyt
        }()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WorkoutCell.self, forCellWithReuseIdentifier: WorkoutCell.CELL_IDENTIFIER)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "containerCell")
        collectionView.dataSource = self
    }
    
    @objc fileprivate func colorButtonPressed() {
        
        guard let windowColor2 = windowSettings.selectedColor, let windowColorText2 = windowSettings.selectedColorText else { return }
        
        windorColor = windowColor2
        windowColorText = windowColorText2
        
        if windowText.count > 1 {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
        
        
    }
    
    @objc fileprivate func keyboardDismiss() {
        self.view.endEditing(true)
    }
    
    @objc fileprivate func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc fileprivate func nextButtonPressed() {
        
        if windowText.count > 1 && windowColorText != nil {
            
            let windowModel = WindowSettingsModel()
            windowModel.windowName = windowText
            windowModel.windowColorText = windowColorText!
            
            do {
                try realm.write {
                    realm.add(windowModel)
                    
                    let addWorkoutVC = AddWorkoutController()
                    addWorkoutVC.windowSettings = windowModel
                    navigationController?.pushViewController(addWorkoutVC, animated: true)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
       
    }
    
}


extension WindowSettingsController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCell.CELL_IDENTIFIER, for: indexPath) as? WorkoutCell else { return UICollectionViewCell() }
        
        cell.lblName.text = windowText
        cell.backgroundColor = windorColor
        
        let containerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "containerCell", for: indexPath)
        
        containerCell.backgroundColor = .clear
        containerCell.setShadow(opacity: 1, radius: 10, offSet: .init(width: 5, height: 10), color: .black)
        containerCell.addSubview(cell)
        _ = cell.anchor(top: containerCell.topAnchor, bottom: containerCell.bottomAnchor, leading: containerCell.leadingAnchor, trailing: containerCell.trailingAnchor)
        if containerCell.subviews.count > 1 {
            containerCell.subviews.first?.removeFromSuperview()
        }
        
        return containerCell
    }
    
    
}

extension WindowSettingsController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text ?? ""
        
        guard let stringRange = Range(range,in: text) else { return false }
        
        let newText = text.replacingCharacters(in: stringRange, with: string)
        
        windowText = text
        if windowText.count > 1 && windowColorText != nil {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
        
        return newText.count < 21
        
    }
    
    
}

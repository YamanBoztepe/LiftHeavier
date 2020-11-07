//
//  ViewController.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 16.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class MainController: UIViewController {
    
    fileprivate let topView = TopViewMC()
    fileprivate let bottomView = BottomViewMC()
    fileprivate let extraView = UIView()
    fileprivate var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    let realm = try! Realm()
    var windowSettingsList : Results<WindowSettingsModel>? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var editButtonPressedCounter = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setCollectionView()
        setLayout(collectionView: collectionView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        windowSettingsList = realm.objects(WindowSettingsModel.self)
        
       
    }
    
    
    fileprivate func setLayout(collectionView : UICollectionView) {
        
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = topView.backgroundColor
        collectionView.backgroundColor = UIColor.rgb(red: 46, green: 46, blue: 46)
        
        [topView,extraView,bottomView,collectionView].forEach { view.addSubview($0) }
        
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/17))
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = bottomView.anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height/17))
        _ = collectionView.anchor(top: topView.bottomAnchor, bottom: bottomView.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        topView.addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        topView.editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        
    }
    
    
    fileprivate func setCollectionView() {
        
        let layout : UICollectionViewFlowLayout = {
            let lyt = UICollectionViewFlowLayout()
            lyt.itemSize = CGSize(width: view.frame.width/2.5, height: view.frame.height/6)
            lyt.sectionInset = UIEdgeInsets(top: view.frame.width/20, left: view.frame.width/20, bottom: 0, right: view.frame.width/20)
            lyt.minimumLineSpacing = (view.frame.width - (topView.frame.width + bottomView.frame.width)) / 7
            return lyt
        }()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WorkoutCell.self, forCellWithReuseIdentifier: WorkoutCell.CELL_IDENTIFIER)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "containerCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    fileprivate func fetchDataForCell(_ indexPath: IndexPath, _ cell: WorkoutCell) {
           if let windowData = windowSettingsList?[indexPath.row] {
               cell.lblName.text = windowData.windowName
               
               switch windowData.windowColorText {
               case "blue":
                   cell.backgroundColor = .rgb(red: 0, green: 0, blue: 255)
               case "red":
                   cell.backgroundColor = .rgb(red: 255, green: 0, blue: 0)
               case "green":
                   cell.backgroundColor = .rgb(red: 0, green: 128, blue: 0)
               case "purple":
                   cell.backgroundColor = .rgb(red: 128, green: 0, blue: 128)
               case "yellow":
                   cell.backgroundColor = .rgb(red: 255, green: 215, blue: 0)
               case "pink":
                   cell.backgroundColor = .rgb(red: 255, green: 0, blue: 255)
               default:
                   cell.backgroundColor = .rgb(red: 0, green: 0, blue: 255)
               }
               
           }
       }
    
    fileprivate func createContainerCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ cell: WorkoutCell) -> UICollectionViewCell {
           let containerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "containerCell", for: indexPath)
           
           containerCell.backgroundColor = .clear
           containerCell.setShadow(opacity: 1, radius: 10, offSet: .init(width: 5, height: 10), color: .black)
           containerCell.addSubview(cell)
           
           _ = cell.anchor(top: containerCell.topAnchor, bottom: containerCell.bottomAnchor, leading: containerCell.leadingAnchor, trailing: containerCell.trailingAnchor)
           
           
           return containerCell
       }
    
    @objc fileprivate func addButtonPressed() {
        editButtonPressedCounter = 0
        let vc = WindowSettingsController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func editButtonPressed() {
        editButtonPressedCounter += 1
    }
    
    @objc fileprivate func deleteIconPressed(button : UIButton) {
        guard let cell = button.superview as? WorkoutCell else { return }
        var temporary = WindowSettingsModel()
        
        for i in 0...collectionView.numberOfItems(inSection: 0)-1 {
            guard let windowInfo = windowSettingsList?[i] else { return }
            
            if cell.lblName.text == windowInfo.windowName {
                temporary = windowInfo
            }
        }
        do {
            try realm.write {
                realm.delete(temporary)
            }
        } catch {
            print(error.localizedDescription)
        }
        collectionView.reloadData()
    }
    
    @objc fileprivate func cellPressed(_ gesture : UITapGestureRecognizer) {
        guard let cell = gesture.view as? WorkoutCell else { return }
        
        for i in 0...collectionView.numberOfItems(inSection: 0)-1 {
            guard let windowInfo = windowSettingsList?[i] else { return }
            
            if cell.lblName.text == windowInfo.windowName {
                let vc = WorkoutBeginController()
                vc.exerciseList = windowInfo.exercises
                vc.cellBackgroundColor = cell.backgroundColor
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


extension MainController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return windowSettingsList?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCell.CELL_IDENTIFIER, for: indexPath) as? WorkoutCell else { return UICollectionViewCell() }
        
        fetchDataForCell(indexPath, cell)
        
        if editButtonPressedCounter % 2 != 0 {
            cell.deleteIcon.isHidden = false
            cell.deleteIcon.addTarget(self, action: #selector(deleteIconPressed(button:)), for: .touchUpInside)
        } else {
            cell.deleteIcon.isHidden = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellPressed(_:)))
            cell.addGestureRecognizer(gestureRecognizer)
        }
        
        
        return createContainerCell(collectionView, indexPath, cell)
        
    }
    
}

extension MainController: CheckExerciseCompleted {
    func isExerciseCompleted(completed: Bool) {
        if completed == true {
            
            let messageLabel : UILabel = {
                let lbl = UILabel()
                lbl.text = ALERT_COMPLETED_TEXT
                lbl.textColor = .green
                lbl.textAlignment = .center
                lbl.numberOfLines = 0
                lbl.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                lbl.layer.cornerRadius = view.frame.width/12
                lbl.clipsToBounds = true
                return lbl
            }()
            view.addSubview(messageLabel)
            _ = messageLabel.anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: view.frame.width/15, bottom: view.frame.width/15, right: view.frame.width/15))
            messageLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/10).isActive = true
           
            messageLabel.frame.origin.y += view.frame.width / 7
            UIView.animate(withDuration: 10, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 7, options: .curveEaseIn) {
                messageLabel.frame.origin.y -= self.view.frame.width / 7
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
                UIView.animate(withDuration: 2) {
                    messageLabel.frame.origin.y += self.view.frame.width / 2
                } completion: { (_) in
                    messageLabel.removeFromSuperview()
                }
            })
        }
    }
    
    
}

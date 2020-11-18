//
//  AddWorkoutControllerViewController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 24.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class AddWorkoutController: UIViewController {
    
    fileprivate let topView = TopViewADC()
    let extraView = UIView()
    fileprivate let tableView = UITableView()
    fileprivate let saveButton = CustomSaveButton()
    
    let realm = try! Realm()
    var exerciseList : Results<ExerciseInfoModel>?
    var windowSettings : WindowSettingsModel? {
        didSet {
            exerciseList = windowSettings?.exercises.sorted(byKeyPath: "exerciseName", ascending: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setTableView()
        topView.addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    
    fileprivate func setLayout() {
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        navigationController?.navigationBar.isHidden = true
        tableView.backgroundColor = view.backgroundColor
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        [extraView,topView,tableView,saveButton].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/17))
        _ = tableView.anchor(top: topView.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = saveButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: nil,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: view.frame.width/2.5, height: view.frame.height/20))
        
        saveButton.positionInCenterSuperView(centerX: view.centerXAnchor, centerY: nil)
    }
    
    fileprivate func setTableView() {
        tableView.register(AddWorkoutCell.self, forCellReuseIdentifier: AddWorkoutCell.IDENTIFIER)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @objc fileprivate func saveButtonPressed() {
        guard let vc = navigationController?.viewControllers.first as? MainController else { return }
        vc.windowSettingsList = realm.objects(WindowSettingsModel.self)
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc fileprivate func addButtonPressed() {
        
        let alertController = UIAlertController(title: ALERT_TITLE, message: ALERT_DESCRIPTION, preferredStyle: .alert)
        
        alertController.addTextField { (txtExerciseName) in
            txtExerciseName.placeholder = EXERCISENAME_PLACEHOLDER
        }
        alertController.addTextField { (txtSetNumber) in
            txtSetNumber.placeholder = EXERCISESET_PLACEHOLDER
            txtSetNumber.keyboardType = .numberPad
        }
        
        let add = UIAlertAction(title: ADD_ACTION, style: .default) { (_) in
            
            let txtExercise = alertController.textFields![0]
            let txtSet = alertController.textFields![1]
            
            if let windowSet = self.windowSettings {
                
                do {
                    try self.realm.write {
                        let exercise = ExerciseInfoModel()
                        
                        if !(txtExercise.text == " " || txtExercise.text?.count == 0) {
                                exercise.exerciseName = txtExercise.text!
                        }else {
                            exercise.exerciseName = EMPTY_TXTEXERCISE
                        }
                        exercise.setNumber = Int(txtSet.text ?? "1") ?? 1
                        
                        if exercise.exerciseName.count > 24 || exercise.setNumber > 20 {
                            exercise.exerciseName = String(exercise.exerciseName.prefix(24))
                            exercise.setNumber = 20
                        }
                        
                        var isItSameExercise : Bool = false
                        
                        for checkExercise in windowSet.exercises {
                            if checkExercise.exerciseName == exercise.exerciseName {
                                isItSameExercise = true
                            }
                        }
                        
                        if isItSameExercise == false {
                            windowSet.exercises.append(exercise)
                        }
                        
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        }
        alertController.addAction(add)
        present(alertController, animated: true, completion: nil)
    }
    
}


extension AddWorkoutController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        saveButton.isEnabled = (exerciseList?.count ?? 0) > 0
        return exerciseList?.count ?? 0
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:AddWorkoutCell.IDENTIFIER, for: indexPath) as? AddWorkoutCell else { return UITableViewCell()}
        
        if let exercise = exerciseList?[indexPath.row] {
            cell.txtExerciseField.text = exercise.exerciseName
            cell.txtSetField.text = "\(exercise.setNumber)"
        }
        cell.isUserInteractionEnabled = false
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        footerView.heightAnchor.constraint(equalToConstant: topView.frame.height).isActive = true
        return footerView
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if let selectedExercise = exerciseList?[indexPath.row] {
                
                do {
                    try realm.write {
                        realm.delete(selectedExercise)
                        print(self.realm.objects(WindowSettingsModel.self))
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        }
    }
}

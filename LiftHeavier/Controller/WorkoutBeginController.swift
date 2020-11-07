//
//  WorkoutBeginController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 26.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class WorkoutBeginController: UIViewController {
    
    let realm = try! Realm()
    var exerciseList : List<ExerciseInfoModel>?
    var exerciseDate : List<ExerciseDate>?
    var currentExerciseDetails : Results<CurrentExerciseDetails>?
    var completedExercises : Results<CompletedExercises>?
    
    fileprivate let extraView = UIView()
    fileprivate let topView = TopViewWithBackButton()
    fileprivate let customSectionLabel : CustomSectionLabel = {
        let lbl = CustomSectionLabel()
        lbl.sectionName.text = EXERCISES_TEXT
        return lbl
    }()
    fileprivate let completeView = UIView()
    fileprivate var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    fileprivate let tableView = UITableView()
    
    var cellBackgroundColor : UIColor?
    var setNumber : Int = 0 {
        didSet {
            print("set number real : \(setNumber)")
            addSetNumber = 1
        }
    }
    
    var addSetNumber : Int = 1 {
        didSet {
            if addSetNumber > setNumber {
                saveButton.isEnabled = true
                print("This is the end Add-Set number : \(addSetNumber)")
            } else {
                saveButton.isEnabled = false
            }
            tableView.reloadData()
        }
    }
    
    var selectedCellRow : Int? {
        didSet {
            exerciseDate = exerciseList![selectedCellRow!].exerciseDateList
            collectionView.reloadData()
        }
    }
    
    var numberOfLiftedWeight : Int?
    var numberOfReps : Int?
    
    fileprivate let saveButton = CustomSaveButton()
    
    var delegate : CheckExerciseCompleted!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setTableView()
        setLayout()
        setTargetToButtons()
        view.keyboardShowObserverForWBC()
        deleteCompletedExercises()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        deleteCurrentDetails()
        deleteCompletedExercises()
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setLayout() {
        saveButton.isEnabled = false
        collectionView.backgroundColor = .clear
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = topView.backgroundColor
        tableView.backgroundColor = .clear
        [extraView,topView,customSectionLabel,collectionView,tableView,saveButton].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: 50))
        _ = customSectionLabel.anchor(top: topView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: 10, left: 10, bottom: 10, right: 10),size: .init(width: 0, height: view.frame.height/20))
        _ = collectionView.anchor(top: customSectionLabel.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/5))
        _ = tableView.anchor(top: collectionView.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = saveButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: nil,size: .init(width: view.frame.width/2.5, height: view.frame.height/20))
        
        saveButton.positionInCenterSuperView(centerX: view.centerXAnchor, centerY: nil)
    }
    
    fileprivate func setCollectionView() {
        let layout : UICollectionViewFlowLayout = {
            let lyt = UICollectionViewFlowLayout()
            lyt.itemSize = CGSize(width: view.frame.height/6, height: view.frame.height/6)
            lyt.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            lyt.scrollDirection = .horizontal
            return lyt
        }()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ExerciseCell.self, forCellWithReuseIdentifier: ExerciseCell.CELL_IDENTIFIER)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func setTableView() {
        
        tableView.register(SetCell.self, forCellReuseIdentifier: SetCell.CELL_IDENTIFIER)
        tableView.delegate = self
        tableView.dataSource = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    fileprivate func setTargetToButtons() {
        topView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    @objc fileprivate func keyboardDismiss() {
        tableView.endEditing(true)
    }
    
    @objc fileprivate func backButtonPressed() {
        
        if exerciseList?.count == completedExercises?.count {
            navigationController?.popViewController(animated: true)
            
        } else {
            let alertController = UIAlertController(title: BACK_ALERT_TITLE, message: BACK_ALERT_MESSAGE, preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: ALERT_ACTION_YES, style: .default) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            let noAction = UIAlertAction(title: ALERT_ACTION_NO, style: .default) { (_) in
                return
            }
            
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func addButtonPressed(_ btn : UIButton) {
        view.endEditing(true)
        guard let numberOfWeight = numberOfLiftedWeight, let reps = numberOfReps else {
            print("empty")
            return
        }
        
        let indexPath = IndexPath(item: addSetNumber-1, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? SetCell else { return }
        
        if numberOfWeight == 0 || reps == 0 {
            if numberOfWeight == 0 {
                cell.weightLiftedTextField.backgroundColor = .red
            }else {
                cell.weightLiftedTextField.backgroundColor = .white
            }
            if reps == 0 {
                cell.repNumberTextField.backgroundColor = .red
            }else {
                cell.repNumberTextField.backgroundColor = .white
            }
            
            return
        } else {
            [cell.weightLiftedTextField,cell.repNumberTextField].forEach { $0.backgroundColor = .white }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = Date()
        let currentDate = dateFormatter.string(from: date)
        
        let currentExerciseDetail = CurrentExerciseDetails()
        currentExerciseDetail.numberOfSet = addSetNumber
        currentExerciseDetail.liftedWeight = numberOfWeight
        currentExerciseDetail.reps = reps
        currentExerciseDetail.date = currentDate
        
        
        do {
            try realm.write {
                realm.add(currentExerciseDetail)
                currentExerciseDetails = realm.objects(CurrentExerciseDetails.self)
            }
        } catch {
            print(error.localizedDescription)
        }
        numberOfLiftedWeight = nil
        numberOfReps = nil
        addSetNumber += 1
        
    }
    
    @objc fileprivate func saveButtonPressed() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = Date()
        let currentDate = dateFormatter.string(from: date)
        let exerciseDate = ExerciseDate()
        exerciseDate.date = currentDate
        
        do {
            try realm.write {
                exerciseList![selectedCellRow!].exerciseDateList.append(exerciseDate)
                
            }
        } catch {
            print(error.localizedDescription)
        }
        
        for details in currentExerciseDetails! {
            do {
                try realm.write {
                    let exerciseDetails = ExerciseDetails()
                    exerciseDetails.liftedWeight = details.liftedWeight
                    exerciseDetails.reps = details.reps
                    exerciseDetails.numberOfSet = details.numberOfSet
                    exerciseDetails.oneRM = Double(details.liftedWeight) / (1.0278 - (Double(details.reps) * 0.0278))
                    exerciseDate.exerciseDetails.append(exerciseDetails)
                }
            } catch {
                print(error.localizedDescription)
            }
        } // End of the loop
        
        do {
            try realm.write {
                let completedExercise = CompletedExercises()
                completedExercise.exerciseName = exerciseList![selectedCellRow!].exerciseName
                completedExercise.setNumber = exerciseList![selectedCellRow!].setNumber
                realm.add(completedExercise)
                self.completedExercises = realm.objects(CompletedExercises.self)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        if exerciseList?.count == completedExercises?.count {
            navigationController?.popViewController(animated: true)
            delegate.isExerciseCompleted(completed: true)
        }
        
        setCompletedTableView()
        self.collectionView.reloadData()
    }
    
    fileprivate func removeZeroBeforeNumber(_ textField: UITextField) {
        if textField.text?.count ?? -1 > 1 {
            var index = 0
            for i in textField.text ?? "" {
                if i == "0" {
                    index += 1
                } else {
                    textField.text! = String(textField.text!.suffix(textField.text!.count-index))
                    break
                }
            }
        }
    }
    fileprivate func fetchCurrentDetailsData(_ indexPath: IndexPath, _ cell: SetCell) {
        if indexPath.row < currentExerciseDetails?.count ?? -1 {
            cell.weightLiftedTextField.text = "\(currentExerciseDetails![indexPath.row].liftedWeight)"
            cell.repNumberTextField.text = "\(currentExerciseDetails![indexPath.row].reps)"
        } else {
            cell.weightLiftedTextField.text = nil
            cell.repNumberTextField.text = nil
        }
    }
    
    fileprivate func deleteCurrentDetails() {
        do {
            try realm.write {
                realm.delete(realm.objects(CurrentExerciseDetails.self))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func deleteCompletedExercises() {
        do {
            try realm.write {
                realm.delete(realm.objects(CompletedExercises.self))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func setOneRMPercentageOfChange(_ cell: SetCell) {
        if let lastWorkout = exerciseDate?.last, let currentWeight = cell.weightLiftedTextField.text, let currentReps = cell.repNumberTextField.text {
            let exercises = lastWorkout.exerciseDetails
            
            for exercise in exercises {
                if exercise.numberOfSet == cell.numberOfSet {
                    if currentWeight.count > 0 && currentReps.count > 0 {
                        let currentOneRepMax = Double(currentWeight)! / (1.0278 - (Double(currentReps)! * 0.0278))
                        
                        if currentOneRepMax > exercise.oneRM {
                            cell.arrowImage.image = UIImage(named: "upArrow")?.withRenderingMode(.alwaysOriginal)
                            cell.amounfOfChange = Int(((currentOneRepMax - exercise.oneRM) / exercise.oneRM) * 100.0)
                        } else {
                            cell.arrowImage.image = UIImage(named: "downArrow")?.withRenderingMode(.alwaysOriginal)
                            cell.amounfOfChange = Int(((exercise.oneRM - currentOneRepMax) / currentOneRepMax) * 100.0)
                        }
                        
                    } else {
                        break
                    }
                }
            }
        } else {
            cell.arrowImage.image = UIImage(named: "upArrow")!.withRenderingMode(.alwaysOriginal)
            cell.amounfOfChange = 0
        }
    }
    
    fileprivate func setCompletedTableView() {
        UIView.animate(withDuration: 0.0) {
            self.tableView.reloadData()
        } completion: { (_) in
            let checkMark = UIImageView(image: UIImage(named: "completed")?.withRenderingMode(.alwaysOriginal))
            let completedText : UILabel = {
                let lbl = UILabel()
                lbl.text = COMPLETED_TEXT
                lbl.font = UIFont.boldSystemFont(ofSize: self.view.frame.width/10)
                lbl.textColor = .white
                return lbl
            }()
            let completeSV : UIStackView = {
                let sv = UIStackView(arrangedSubviews: [checkMark,completedText])
                sv.axis = .vertical
                sv.alignment = .center
                return sv
            }()
            
            self.completeView.addSubview(completeSV)
            
            self.view.addSubview(self.completeView)
            self.completeView.backgroundColor = self.view.backgroundColor
            
            _ = self.completeView.anchor(top: self.tableView.topAnchor, bottom: self.tableView.bottomAnchor, leading: self.tableView.leadingAnchor, trailing: self.tableView.trailingAnchor)
            completeSV.positionInCenterSuperView(centerX: self.completeView.centerXAnchor, centerY: self.completeView.centerYAnchor)
        }
        
    }
    
    fileprivate func deleteCompleteView() {
        self.completeView.subviews.forEach { $0.removeFromSuperview() }
        self.completeView.removeFromSuperview()
    }
}



extension WorkoutBeginController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exerciseList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCell.CELL_IDENTIFIER, for: indexPath) as? ExerciseCell,let exercise = exerciseList?[indexPath.row] else { return UICollectionViewCell() }
        
        if (selectedCellRow ?? -1) == indexPath.row {
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.white.cgColor
        } else {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.black.cgColor
        }
        cell.lblNameText.text = exercise.exerciseName
        
        cell.backgroundColor = cellBackgroundColor
        completedExercises?.forEach { completedExercise in
            if completedExercise.exerciseName == exercise.exerciseName && completedExercise.setNumber == exercise.setNumber {
                cell.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let exercise = exerciseList?[indexPath.row] else { return }
        deleteCurrentDetails()
        deleteCompleteView()
        selectedCellRow = indexPath.row
        setNumber = exercise.setNumber
        
        guard let completedExercises = completedExercises else { return }
        
        for isCompletedExercise in  completedExercises {
            
            if exercise.exerciseName == isCompletedExercise.exerciseName && exercise.setNumber == isCompletedExercise.setNumber {
                setCompletedTableView()
                return
            }
        }
    }
    
    
}

extension WorkoutBeginController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if addSetNumber > setNumber {
            return setNumber
        }else {
            return addSetNumber
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetCell.CELL_IDENTIFIER, for: indexPath) as? SetCell else { return UITableViewCell()}
        
        fetchCurrentDetailsData(indexPath, cell)
        
        [cell.weightLiftedTextField,cell.repNumberTextField].forEach { $0.delegate = self }
        cell.weightLiftedTextField.tag = 100 + addSetNumber
        cell.repNumberTextField.tag = 1000 + addSetNumber
        
        if indexPath.row < addSetNumber-1 {
            cell.addButton.isHidden = true
            cell.percentageStackView.isHidden = false
        } else {
            cell.addButton.isHidden = false
            cell.percentageStackView.isHidden = true
        }
        
        [cell.weightLiftedTextField,cell.repNumberTextField].forEach { $0.isUserInteractionEnabled = !(cell.addButton.isHidden) }
        
        cell.numberOfSet = indexPath.row + 1
        setOneRMPercentageOfChange(cell)
        cell.addButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        cell.contentView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        footerView.heightAnchor.constraint(equalToConstant: topView.frame.height).isActive = true
        return footerView
    }
    
    
}

extension WorkoutBeginController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText : NSString = textField.text as NSString? else { return false}
        let newText = textFieldText.replacingCharacters(in: range, with: string)
        
        return newText.count <= 4
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 100 + addSetNumber {
            removeZeroBeforeNumber(textField)
            numberOfLiftedWeight = Int(textField.text ?? "-1")
            
        } else if textField.tag == 1000 + addSetNumber {
            removeZeroBeforeNumber(textField)
            numberOfReps = Int(textField.text ?? "-1")
        }
        
    }
}

protocol CheckExerciseCompleted {
    func isExerciseCompleted(completed : Bool)
}

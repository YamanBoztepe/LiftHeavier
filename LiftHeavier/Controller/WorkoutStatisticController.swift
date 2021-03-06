//
//  WorkoutStatisticController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 8.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class WorkoutStatisticController: UIViewController {
    
    fileprivate let extraView = UIView()
    fileprivate let topView = TopViewWithBackButton()
    fileprivate let addButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "detailsButton"), for: .normal)
        return btn
    }()
    fileprivate let oneRepMaxLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    let realm = try! Realm()
    var windowSettingsList  = WindowSettingsModel()
    var currentExercise : ExerciseInfoModel? {
        didSet {
            collectionView.reloadData()
            setChart()
            oneRepMaxLbl.text = String(format:"\(YOUR_ONERM)%.0f",getBiggestOneRM())
        }
    }
    
    fileprivate let barChart = BarChartView()
    
    fileprivate var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setLayout(collectionView)
    }
    
    fileprivate func setLayout(_ collectionView: UICollectionView) {
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        collectionView.backgroundColor = .clear
        addButton.isHidden = true
        [extraView,topView,collectionView,barChart,oneRepMaxLbl,addButton].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/15))
        _ = collectionView.anchor(top: topView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.width/7))
        _ = barChart.anchor(top: collectionView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: view.frame.height/30, left: view.frame.height/50, bottom: 0, right: view.frame.height/50),size: .init(width: 0, height: view.frame.height/2))
        _ = oneRepMaxLbl.anchor(top: barChart.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/8))
        _ = addButton.anchor(top: oneRepMaxLbl.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: nil,padding: .init(top: view.frame.height/30, left: 0, bottom: 0, right: 0))
        
        addButton.positionInCenterSuperView(centerX: view.centerXAnchor, centerY: nil)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        oneRepMaxLbl.font = UIFont.boldSystemFont(ofSize: view.frame.width/20)
        topView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func setChart() {
        
        guard let currentDate = currentExercise?.exerciseDateList else { return }
        var numberOfDates = [Int]()
        var entries = [BarChartDataEntry]()
        
        for date in currentDate {
            if let numberDate = Int(date.date.prefix(4) + date.date.prefix(7).suffix(2)) {
                numberOfDates.append(numberDate)
            }
        }
        var uniqueDates = Array(Set(numberOfDates))
        uniqueDates.sort()
        
        if let lastElementOfDates = uniqueDates.last {
            uniqueDates.forEach { date in
                if date <= lastElementOfDates-100 {
                    print("Deleted item : ",date)
                    uniqueDates.remove(at: uniqueDates.firstIndex(of: date)!)
                    
                }
            }
        }
        
        print(uniqueDates)
        
        for uniqueDate in uniqueDates {
            var oneRM = 0.0
            var oneRmCounter = 0
            var sets = 0
            for date in currentDate {
                if let numberDate = Int(date.date.prefix(4) + date.date.prefix(7).suffix(2)) {
                    if uniqueDate == numberDate {
                        for details in date.exerciseDetails {
                            oneRM += details.oneRM
                            sets = details.numberOfSet
                        }
                        oneRmCounter += 1
                        print("OneRM : ",oneRM," Step : \(oneRmCounter)")
                    }
                }
            }
            print("Final OneRM : ",oneRM,"--- End ---- Counter : ",oneRmCounter)
            let averageOneRM = oneRM / (Double(oneRmCounter) * Double(sets))
            let currentMonth = "\(uniqueDate)".suffix(2)
            entries.append(BarChartDataEntry(x: Double(currentMonth) ?? 1, y: Double(String(format: "%.2f",averageOneRM)) ?? 1))
        }
        barChart.data = nil
        addButton.isHidden = true
        
        //modify chart view
        if currentDate.count > 0 {
            let set = BarChartDataSet(entries: entries)
            set.colors = ChartColorTemplates.material()
            set.valueColors = [UIColor.white]
            set.valueFont = UIFont.boldSystemFont(ofSize: view.frame.width/30)
            let data = BarChartData(dataSet: set)
            barChart.data = data
            
            barChart.rightAxis.enabled = false
            barChart.leftAxis.enabled = false
            let customLegend = LegendEntry(label: AVERAGE_ONERM, form: .none, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: .white)
            barChart.legend.textColor = .white
            barChart.legend.entries = [customLegend]
            barChart.xAxis.labelTextColor = .white
            barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
            
            addButton.isHidden = false
            
        }
        
        
    }
    
    fileprivate func setCollectionView() {
        
        let layout : UICollectionViewFlowLayout = {
           let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: view.frame.width/2, height: view.frame.width/12)
            layout.sectionInset = UIEdgeInsets(top: view.frame.width/50, left: view.frame.width/20, bottom: view.frame.width/50, right: view.frame.width/20)
            layout.scrollDirection = .horizontal
            return layout
        }()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ExerciseStatisticCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc fileprivate func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    @objc fileprivate func addButtonPressed() {
        let vc = MoreDetailsController()
        vc.selectedExerciseDates = currentExercise!.exerciseDateList
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
    }
    
    fileprivate func getBiggestOneRM() -> Double {
        guard let details = currentExercise?.exerciseDateList.last?.exerciseDetails else { return 0 }
        var biggestOneRM = 0.0
        for detail in details {
            if detail.oneRM > biggestOneRM {
                biggestOneRM = detail.oneRM
            }
        }
        return biggestOneRM
    }
}

extension WorkoutStatisticController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return windowSettingsList.exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ExerciseStatisticCell else { return UICollectionViewCell()}
        
        cell.lblText.text = windowSettingsList.exercises[indexPath.row].exerciseName
        
        if let currentExercise = currentExercise {
            if cell.lblText.text == currentExercise.exerciseName {
                cell.layer.borderWidth = 3
                cell.layer.borderColor = UIColor.gray.cgColor
            }else {
                cell.layer.borderWidth = 0
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentExercise = windowSettingsList.exercises[indexPath.row]
    }
  
}

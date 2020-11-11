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
    
    let realm = try! Realm()
    var windowSettingsList  = WindowSettingsModel()
    var currentExercise : ExerciseInfoModel? {
        didSet {
            collectionView.reloadData()
            setChart()
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
        extraView.backgroundColor = topView.backgroundColor
        collectionView.backgroundColor = .clear
        [extraView,topView,collectionView,barChart].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/15))
        _ = collectionView.anchor(top: topView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.width/7))
        _ = barChart.anchor(top: collectionView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: view.frame.height/30, left: view.frame.height/50, bottom: 0, right: view.frame.height/50),size: .init(width: 0, height: view.frame.height/2))
        
        topView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func setChart() {
        
        var exerciseDates = [Int]()
        guard let currentDateList = currentExercise?.exerciseDateList else { return }
        for dates in currentDateList {
            let numberOfMonth = Int((dates.date.prefix(7).suffix(2))) ?? 1
            exerciseDates.append(numberOfMonth)
            
        }
        
        let uniqueDates = Array(Set(exerciseDates))
        var entries = [BarChartDataEntry]()
        var oneRM = 0.0
        var averageOneRM = 0.0
        print("dates :",uniqueDates)
        
        for date in uniqueDates {
            averageOneRM = 0.0
            
        }
        
        //modify chart view
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        set.valueColors = [UIColor.white]
        let data = BarChartData(dataSet: set)
        barChart.data = data
        
        barChart.rightAxis.enabled = false
        barChart.leftAxis.enabled = false
        barChart.legend.enabled = false
        barChart.xAxis.labelTextColor = .white
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        
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

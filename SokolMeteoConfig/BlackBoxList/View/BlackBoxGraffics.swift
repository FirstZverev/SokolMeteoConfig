//
//  BlackBoxGraffics.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 05.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import Charts

class BlackBoxGraffics: UIViewController {
    
    var name: Int!
    var nameDeviceBox: String!

    var lineChartData = LineChartData()
    var constraints: [NSLayoutConstraint] = []
    var constraintsTwo: [NSLayoutConstraint] = []
    var constraintsThree: [NSLayoutConstraint] = []

    lazy var lineChartDataSet: LineChartDataSet = {
        let lineChartDataSet = LineChartDataSet(entries: yValues, label: "Graffics")
        lineChartDataSet.mode = .linear
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.lineWidth = 3
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.drawVerticalHighlightIndicatorEnabled = false
        lineChartDataSet.fill = Fill(color: UIColor(rgb: 0xBE449E))
        lineChartDataSet.fillAlpha = 0.2
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.setColor(UIColor(rgb: 0xBE449E), alpha: 1.0)
        return lineChartDataSet
    }()
    
    lazy var lineChartView: LineChartView = {
        let chart = LineChartView()
        chart.backgroundColor = .clear
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.rightAxis.enabled = false
        chart.setVisibleXRangeMaximum(10)
        let xAxis = chart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .black
        xAxis.labelPosition = .bottom
        xAxis.labelCount = 3
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        let xValuesFormatter = DateFormatter()
            xValuesFormatter.dateFormat = "dd-MM-yy HH:mm"
        
        
        let leftAxis = chart.leftAxis
        leftAxis.labelTextColor = .black
        let lvlBlackBoxInt = 4
        leftAxis.axisMaximum = Double(lvlBlackBoxInt + 10)
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        chart.animate(xAxisDuration: 1)
        return chart
    }()
    
    lazy var labelName: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Метеостанция \(nameDeviceBox ?? "0")"
        label.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        label.textColor = .black
        return label
    }()
    
    lazy var labelNameParametr: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ViewModelMeteoData().menuMain[name].name
        label.numberOfLines = 0
        label.font = UIFont(name:"FuturaPT-Light", size: 16.0)
        label.textColor = .black
        return label
    }()
    
    lazy var dayButton: UIButton = {
       let button = UIButton()
        button.setTitle("день", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectRangeDay), for: .touchUpInside)

        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var linePurpleSelected: UIView = {
       let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(rgb: 0xBE449E)
        return button
    }()
    
    lazy var containerButtons: UIView = {
       let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 5.0
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        button.layer.shadowOffset = CGSize.zero
        return button
    }()
    lazy var weekButton: UIButton = {
       let button = UIButton()
        button.setTitle("неделя", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectRangeWeek), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var mouthButton: UIButton = {
       let button = UIButton()
        button.setTitle("месяц", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectRangeMouth), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.image = UIImage(named: "back")!
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
//        backView.addSubview(back)
        backView.translatesAutoresizingMaskIntoConstraints = false
        return backView
    }()
    
    lazy var imageParametr: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ViewModelMeteoData().menuMain[name].image!)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var switchGrafficsOrTable: UIButton = {
        let image = UIButton()
        image.setImage(UIImage(named: "switchTable"), for: .normal)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addTarget(self, action: #selector(switchImageSegmented), for: .touchUpInside)
        return image
    }()
    
    @objc func switchImageSegmented() {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        let blackBoxTable = BlackBoxTable()
        blackBoxTable.name = name
        blackBoxTable.nameDeviceBox = nameDeviceBox
        self.navigationController?.pushViewController(blackBoxTable, animated: false)

    }
    var yValues: [ChartDataEntry] = [
        
    ]
    func selectRange(int: Int) {
        lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)
        lineChartView.data = lineChartData
        lineChartView.leftAxis.axisMaximum = Double(200)
        lineChartView.setVisibleXRangeMaximum(Double(20*int))
        lineChartView.setVisibleXRangeMinimum(Double(20*int))
        lineChartView.animate(xAxisDuration: 1)
        lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)
        lineChartView.data = lineChartData
        lineChartView.leftAxis.axisMaximum = Double(200)
        lineChartView.setVisibleXRangeMinimum(1)
        lineChartView.animate(xAxisDuration: 1)
    }
    @objc func selectRangeDay() {
        NSLayoutConstraint.deactivate(constraintsTwo)
        NSLayoutConstraint.deactivate(constraintsThree)
        NSLayoutConstraint.activate(constraints)
        selectRange(int: 1)
    }
    @objc func selectRangeWeek() {
        NSLayoutConstraint.deactivate(constraints)
        NSLayoutConstraint.deactivate(constraintsThree)
        NSLayoutConstraint.activate(constraintsTwo)
        selectRange(int: 2)
    }
    @objc func selectRangeMouth() {
        NSLayoutConstraint.deactivate(constraintsTwo)
        NSLayoutConstraint.deactivate(constraints)
        NSLayoutConstraint.activate(constraintsThree)
        selectRange(int: 3)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .allButUpsideDown
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let viewControllers = navigationController?.viewControllers,
              let index = viewControllers.firstIndex(of: self) else { return }
        navigationController?.viewControllers.remove(at: index)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...100 {
            yValues.append(ChartDataEntry(x: Double(i), y: Double(2 * i) * 0.8))
        }
        view.backgroundColor = .white
        let customNavigationBar = createCustomNavigationBar(title: "",fontSize: screenW / 22)
        self.hero.isEnabled = true
        view.sv(customNavigationBar, backView, switchGrafficsOrTable)
        backView.addTapGesture { [self] in popVC() }
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavigationBar.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 10).isActive = true

        switchGrafficsOrTable.bottomAnchor.constraint(equalTo: customNavigationBar.bottomAnchor).isActive = true
        switchGrafficsOrTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10).isActive = true
        
        backView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        backView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10).isActive = true



//        lineChartDataSet = LineChartDataSet(entries: yValues, label: "Level")
        lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)
        lineChartView.data = lineChartData
        lineChartView.leftAxis.axisMaximum = Double(200)
        lineChartView.setVisibleXRangeMaximum(20)
        lineChartView.animate(xAxisDuration: 1)
        
        cosntrains()
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func cosntrains() {

        view.sv(lineChartView, labelName, labelNameParametr, imageParametr, containerButtons)
        containerButtons.sv(dayButton ,weekButton, mouthButton,linePurpleSelected)
        labelName.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 20).isActive = true
        labelName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        labelNameParametr.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 1).isActive = true
        labelNameParametr.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        labelNameParametr.trailingAnchor.constraint(equalTo: imageParametr.leadingAnchor, constant: -10).isActive = true

        imageParametr.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 20).isActive = true
        imageParametr.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        imageParametr.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        lineChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        lineChartView.topAnchor.constraint(equalTo: labelNameParametr.bottomAnchor).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: dayButton.topAnchor).isActive = true
        
        dayButton.topAnchor.constraint(equalTo: lineChartView.bottomAnchor).isActive = true
        dayButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        dayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dayButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        
        weekButton.topAnchor.constraint(equalTo: lineChartView.bottomAnchor).isActive = true
        weekButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        weekButton.leadingAnchor.constraint(equalTo: dayButton.trailingAnchor).isActive = true
        weekButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true

        mouthButton.topAnchor.constraint(equalTo: lineChartView.bottomAnchor).isActive = true
        mouthButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mouthButton.leadingAnchor.constraint(equalTo: weekButton.trailingAnchor).isActive = true
        mouthButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        
        containerButtons.topAnchor.constraint(equalTo: dayButton.topAnchor).isActive = true
        containerButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        linePurpleSelected.topAnchor.constraint(equalTo: containerButtons.topAnchor).isActive = true
        linePurpleSelected.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        linePurpleSelected.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        constraints = [
            linePurpleSelected.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ]
        constraintsTwo = [
            linePurpleSelected.leadingAnchor.constraint(equalTo: dayButton.trailingAnchor)
        ]
        constraintsThree = [
            linePurpleSelected.leadingAnchor.constraint(equalTo: weekButton.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

//
//  BlackBoxController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 09.06.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift
import NVActivityIndicatorView

protocol BlackBoxDelegate: class {
    func buttonTapBlackBox()
}

class BlackBoxController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    lazy var realm:Realm = {
        return try! Realm()
    }()
    private weak var calendar: FSCalendar!
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    
    private var datesRange: [Date]?

    weak var delegate: BlackBoxDelegate?
    
    lazy var viewAlpha: UIView = {
        let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return viewAlpha
    }()
    lazy var activityIndicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .zero, type: .ballGridPulse, color: UIColor.purple)
        view.frame.size = CGSize(width: 50, height: 50)
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.center = viewAlpha.center
        return view
    }()
    
    lazy var alertView: CustomLoadingBlackBox = {
        let alertView: CustomLoadingBlackBox = CustomLoadingBlackBox.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
       let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
    
    fileprivate lazy var getDataButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(rgb: 0xBE449E)
        view.layer.cornerRadius = 20
        view.setTitle("Запросить данные", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var breakBox: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(rgb: 0xBE449E)
        view.layer.cornerRadius = 10
        view.setTitle("Стоп", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate func constraints() {
        self.calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 + 10).isActive = true
        self.calendar.bottomAnchor.constraint(equalTo: getDataButton.topAnchor, constant: -30).isActive = true
        self.calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        self.calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
//        breakBox.bottomAnchor.constraint(equalTo: self.calendar.topAnchor, constant: -10).isActive = true
//        breakBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        breakBox.widthAnchor.constraint(equalToConstant: 70).isActive = true
//        breakBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        getDataButton.topAnchor.constraint(equalTo: self.calendar.bottomAnchor, constant: 20).isActive = true
        getDataButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        getDataButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        getDataButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        getDataButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
    
    fileprivate func confirationCalendar() {
        let calendar = FSCalendar()
        calendar.backgroundColor = .white
        calendar.firstWeekday = 2
        calendar.appearance.todayColor = .black
        calendar.appearance.headerTitleColor = UIColor(rgb: 0xBE449E)
        calendar.appearance.headerDateFormat = "LLLL yyyy"
        calendar.appearance.weekdayTextColor = UIColor(rgb: 0xBE449E)
        calendar.appearance.selectionColor = UIColor(rgb: 0xBE449E)
        calendar.appearance.headerTitleFont = UIFont(name:"FuturaPT-Medium", size: 20.0)
        calendar.appearance.weekdayFont = UIFont(name:"FuturaPT-Light", size: 20.0)
        calendar.appearance.titleFont = UIFont(name:"FuturaPT-Light", size: 20.0)
        calendar.scrollDirection = .vertical
        calendar.appearance.separators = .none
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
        calendar.pagingEnabled = false
        calendar.dataSource = self
        calendar.delegate = self
        calendar.locale = Locale(identifier: "RU")
        calendar.allowsMultipleSelection = true
        calendar.placeholderType = .none
        calendar.layer.cornerRadius = 20
        calendar.layer.shadowRadius = 5.0
        calendar.layer.shadowOpacity = 0.2
        calendar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        view.sv(calendar)
        self.calendar = calendar
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if Access_Allowed == 0 {
            reload = 27
            self.delegate?.buttonTapBlackBox()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backView.tintColor = .black
        backView.hero.id = "backView"
        
        let customNavigationBar = createCustomNavigationBar(title: "ЧЁРНЫЙ ЯЩИК",fontSize: screenW / 22)
        self.hero.isEnabled = true
        customNavigationBar.hero.id = "BlackBox"
        view.sv(
            customNavigationBar
        )
        
        view.addSubview(backView)
//        view.addSubview(breakBox)
        view.addSubview(getDataButton)

        breakBox.addTapGesture {
            reload = 6
            self.delegate?.buttonTapBlackBox()
        }
        
        backView.addTapGesture {
            self.navigationController?.popViewController(animated: true)
        }
        
        getDataButton.addTapGesture { [self] in
            if firstDate != nil {
                viewAlpha.isHidden = false
                reload = 3
                let dateRangeFirst = self.datesRange?.first
                let dateRangeLast = self.datesRange?.last
                dateFirst = Int(dateRangeFirst?.timeIntervalSince1970 ?? 0)
                dateLast = Int(dateRangeLast?.timeIntervalSince1970 ?? 0) + 86400
                print(dateFirst)
                print(dateLast)
                self.delegate?.buttonTapBlackBox()
                do {
                    let config = Realm.Configuration(
                        schemaVersion: 1,
                        
                        migrationBlock: { migration, oldSchemaVersion in
                            if (oldSchemaVersion < 1) {
                            }
                        })

                    Realm.Configuration.defaultConfiguration = config
                    print(Realm.Configuration.defaultConfiguration.fileURL!)
                    
                    let realmCheck = realm.objects(BoxModel.self).filter("nameDevice = %@", nameDevice)
                    try realm.write {
                        realm.delete(realmCheck)
                    }
                } catch {
                    print("error getting xml string: \(error)")
                }
                if Access_Allowed != 0 {
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    blackBoxStart = true
                    viewAlpha.isHidden = true
                    self.setAlert()
                    self.animateIn()
                }
                if demoMode {
                    DispatchQueue.global(qos: .utility).sync {
                        for i in 10...31 {
                            var stringAll = ""
                            for j in 10...23 {
                                stringAll = "\(i)0121;\(j)5738;5550.9438;E;04905.6758;N;0;0;88;5;0;0;0;96,90;NA;t:2:\(Double.random(in: -25...30)),WD:1:\(Int.random(in: 1...20)),WV:2:\(Double.random(in: 0...10).roundToDecimal(2)),WM:2:\(Double.random(in: 0...10).roundToDecimal(2)),PR:2:\(Double.random(in: 0...10).roundToDecimal(2)),HM:1:0,RN:2:0.00,UV:1:0,UVI:1:0,L:1:0,LI:1:0,Upow:2:\(Double.random(in: 2.8...3.7).roundToDecimal(2)),Uext:2:0.0,KS:1:0,RSSI:1:-\(Int.random(in: 10...60)),TR:1:578,EVS:1:4"
                                let result = stringAll.components(separatedBy: [":",";","=",",","\r","\n"])
                                
                                let fullString = stringAll.components(separatedBy: "\r\n")
                                var ab = result
                                if ab[0].count == 6 && ab[1].count == 6 {
                                    ab[0].insert(".", at: ab[0].index(ab[0].startIndex, offsetBy: 2))
                                    ab[0].insert(".", at: ab[0].index(ab[0].startIndex, offsetBy: 5))
                                    
                                    ab[1].insert(":", at: ab[1].index(ab[1].startIndex, offsetBy: 2))
                                    ab[1].insert(":", at: ab[1].index(ab[1].startIndex, offsetBy: 5))
                                    let a = "\(ab[0]) \(ab[1])"
                                    let account = BoxModel()
                                    account.id = countStringBlackBox
                                    account.nameDevice = nameDevice
                                    account.time = "\(stringTounixTime(dateString: a))"
                                    account.allString = fullString[0]
                                    if ab.contains("t") {
                                        let indexOfPerson = ab.firstIndex{$0 == "t"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("t\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrt = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("WD") {
                                        let indexOfPerson = ab.firstIndex{$0 == "WD"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("WD\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrWD = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("WV") {
                                        let indexOfPerson = ab.firstIndex{$0 == "WV"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("WV\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrWV = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("WM") {
                                        let indexOfPerson = ab.firstIndex{$0 == "WM"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("WM\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrWM = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("PR") {
                                        let indexOfPerson = ab.firstIndex{$0 == "PR"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("PR\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrPR = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("HM") {
                                        let indexOfPerson = ab.firstIndex{$0 == "HM"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("HM\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrHM = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("RN") {
                                        let indexOfPerson = ab.firstIndex{$0 == "RN"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("RN\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrRN = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("UV") {
                                        let indexOfPerson = ab.firstIndex{$0 == "UV"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("UV\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrUV = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("UVI") {
                                        let indexOfPerson = ab.firstIndex{$0 == "UVI"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("UVI\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrUVI = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("L") {
                                        let indexOfPerson = ab.firstIndex{$0 == "L"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("L\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrL = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("LI") {
                                        let indexOfPerson = ab.firstIndex{$0 == "LI"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("LI\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrLI = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("Upow") {
                                        let indexOfPerson = ab.firstIndex{$0 == "Upow"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                print("Upow\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrUpow = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("Uext") {
                                        let indexOfPerson = ab.firstIndex{$0 == "Uext"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("Uext\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrUext = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("KS") {
                                        let indexOfPerson = ab.firstIndex{$0 == "KS"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("KS\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrKS = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("RSSI") {
                                        let indexOfPerson = ab.firstIndex{$0 == "RSSI"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("RSSI\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrRSSI = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("TR") {
                                        let indexOfPerson = ab.firstIndex{$0 == "TR"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("TR\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrTR = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    if ab.contains("EVS") {
                                        let indexOfPerson = ab.firstIndex{$0 == "EVS"}
                                        if ab.count > indexOfPerson! + 2 {
                                            //                                    print("EVS\(countStringBlackBox): \(ab[indexOfPerson! + 2])")
                                            account.parametrEVS = "\(ab[indexOfPerson! + 2])"
                                        }
                                    }
                                    let realm: Realm  = {
                                        return try! Realm()
                                    }()
                                    do {
                                        let config = Realm.Configuration(
                                            schemaVersion: 1,
                                            
                                            migrationBlock: { migration, oldSchemaVersion in
                                                if (oldSchemaVersion < 1) {
                                                }
                                            })
                                        Realm.Configuration.defaultConfiguration = config
                                        try realm.write {
                                            realm.add(account)
                                        }
                                    } catch {
                                        print("error getting xml string: \(error)")
                                    }
                                }
                            }
                            countStringBlackBox += 1
                            DispatchQueue.main.async { [self] in
                                alertView.labelCountSave.text = "\(countStringBlackBox)"
                                stringAll.removeAll()
                            }
                        }
                    }
                    alertView.CustomEnter.isEnabled = true
                    animateOut()
                    let blackBoxMeteoDataController = BlackBoxMeteoDataController()
                    blackBoxMeteoDataController.nameDeviceBlackBox = nameDevice
                    navigationController?.pushViewController(blackBoxMeteoDataController, animated: true)
                    alertView.CustomEnter.text("Обработка")
                }
            } else {
                showToast(message: "Необходимо выбрать дату", seconds: 1.0)
            }
        }
        
        confirationCalendar()
        constraints()
        viewAlpha.isHidden = true
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(viewAlpha)
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return endOfMonth()
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(day: -93), to: Date())!
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        reload = 27
        delegate?.buttonTapBlackBox()
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            print("datesRange contains: \(datesRange!)")
            return
        }

        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]

                print("datesRange contains: \(datesRange!)")

                return
            }

            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last

            for d in range {
                calendar.select(d)
            }

            datesRange = range

            print("datesRange contains: \(datesRange!)")

            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []

            print("datesRange contains: \(datesRange!)")
        }
        
    }
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:

        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }
    }
}


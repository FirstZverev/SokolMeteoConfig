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


protocol BlackBoxDelegate: class {
    func buttonTapBlackBox()
}

class BlackBoxController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    private weak var calendar: FSCalendar!
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    
    private var datesRange: [Date]?

    weak var delegate: BlackBoxDelegate?
    
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
        reload = 27
        self.delegate?.buttonTapBlackBox()
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
                reload = 3
                let dateRangeFirst = self.datesRange?.first
                let dateRangeLast = self.datesRange?.last
                dateFirst = Int(dateRangeFirst?.timeIntervalSince1970 ?? 0)
                dateLast = Int(dateRangeLast?.timeIntervalSince1970 ?? 0) + 86400
                print(dateFirst)
                print(dateLast)
                self.delegate?.buttonTapBlackBox()
                do {
                    let realm: Realm  = {
                        return try! Realm()
                    }()
                    let config = Realm.Configuration(
                        schemaVersion: 0,
                        
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
                    self.setAlert()
                    self.animateIn()
                }
            } else {
                showToast(message: "Необходимо выбрать дату", seconds: 1.0)
            }
        }
            
        confirationCalendar()
        constraints()
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


//
//  BlackBoxTable.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 06.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import RealmSwift
import NVActivityIndicatorView

class BlackBoxTable: UIViewController {
    
    var name: Int!
    var nameDeviceBox: String!
    var parametrValues:  Results<BoxModel>?
    var timeHour: [String] = []
    var valueParametrs: [String] = []
    var viewModel: TableViewViewModelType?
    
    var dateNext = ""
    var dateCurrent = 0
    
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tableView.backgroundColor = .clear
        return tableView
    }()
    lazy var labelName: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Метеостанция \(nameDeviceBox ?? "0")"
        label.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        label.textColor = .black
        return label
    }()
    
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
    
    lazy var labelNameParametr: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ModelViewBlackBox().menuMain[name].name
        label.numberOfLines = 0
        label.font = UIFont(name:"FuturaPT-Light", size: 16.0)
        label.textColor = .black
        return label
    }()
    
    lazy var dayButton: UIButton = {
       let button = UIButton()
        button.setTitle("\(unixTimeStringtoStringOnlyDate(unixTime: (parametrValues?.last!.time)!))", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
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
    
    lazy var imageParametr: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ModelViewBlackBox().menuMain[name].image!)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var switchGrafficsOrTable: UIButton = {
        let image = UIButton()
        image.setImage(UIImage(named: "switchGraffic"), for: .normal)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addTarget(self, action: #selector(switchImageSegmented), for: .touchUpInside)
        return image
    }()
    
    lazy var backGrafficsOrTable: UIButton = {
        let image = UIButton()
        image.setImage(UIImage(named: "backTable"), for: .normal)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addTarget(self, action: #selector(backImageSegmented), for: .touchUpInside)
        return image
    }()
    
    lazy var nextGrafficsOrTable: UIButton = {
        let image = UIButton()
        image.setImage(UIImage(named: "nextTable"), for: .normal)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addTarget(self, action: #selector(nextImageSegmented), for: .touchUpInside)
        return image
    }()
    @objc func nextImageSegmented() {
        viewAlpha.isHidden = false
        let a = dateNext
        let b = stringTounixTimeOnlyData(dateString: a)
        let c = b + 86400
        let d = unixTimeInttoStringOnlyDate(unixTime: c)
        dateNext = d
        dateCurrent = stringTounixTimeOnlyData(dateString: d)
        dayButton.setTitle("\(d)", for: .normal)
        timeHour.removeAll()
        valueParametrs.removeAll()
        let timeCurrentString = dateNext
        let timeCurrent = stringTounixTimeOnlyData(dateString: timeCurrentString)
        let timeCurrentNextDay = timeCurrent + 86400
        for i in 0...parametrValues!.count - 1 {
            let timeString = unixTimeStringtoStringOnlyDate(unixTime: (parametrValues?[i].time)!)
            print("timeCurrentNextDay: \(timeCurrentNextDay)")
            print("timeCurrent: \(timeCurrent)")
            let time = stringTounixTimeOnlyData(dateString: timeString)
            print("time: \(time)")
            if time == timeCurrent && time < timeCurrentNextDay {
                let timeStringNew = unixTimeStringtoStringOnlyHour(unixTime: (parametrValues?[i].time)!)
                timeHour.append(timeStringNew)
                var nameParametr = 0.0
                switch name {
                case 1:
                    nameParametr = ((parametrValues?[i].parametrt)! as NSString).doubleValue
                case 2:
                    nameParametr = ((parametrValues?[i].parametrWD)! as NSString).doubleValue
                case 3:
                    nameParametr = ((parametrValues?[i].parametrWV)! as NSString).doubleValue
                case 4:
                    nameParametr = ((parametrValues?[i].parametrWM)! as NSString).doubleValue
                case 5:
                    nameParametr = ((parametrValues?[i].parametrPR)! as NSString).doubleValue
                case 6:
                    nameParametr = ((parametrValues?[i].parametrHM)! as NSString).doubleValue
                case 7:
                    nameParametr = ((parametrValues?[i].parametrRN)! as NSString).doubleValue
                case 8:
                    nameParametr = ((parametrValues?[i].parametrUV)! as NSString).doubleValue
                case 9:
                    nameParametr = ((parametrValues?[i].parametrUVI)! as NSString).doubleValue
                case 10:
                    nameParametr = ((parametrValues?[i].parametrL)! as NSString).doubleValue
                case 11:
                    nameParametr = ((parametrValues?[i].parametrLI)! as NSString).doubleValue
                case 12:
                    nameParametr = ((parametrValues?[i].parametrUpow)! as NSString).doubleValue
                case 13:
                    nameParametr = ((parametrValues?[i].parametrUext)! as NSString).doubleValue
                case 14:
                    nameParametr = ((parametrValues?[i].parametrKS)! as NSString).doubleValue
                case 15:
                    nameParametr = ((parametrValues?[i].parametrRSSI)! as NSString).doubleValue
                case 16:
                    nameParametr = ((parametrValues?[i].parametrTR)! as NSString).doubleValue
                case 17:
                    nameParametr = ((parametrValues?[i].parametrEVS)! as NSString).doubleValue
                default:
                    print("")
                }
                valueParametrs.append("\(nameParametr)")
            }
        }
        tableView.reloadData()
    }
    
    @objc func backImageSegmented() {
        viewAlpha.isHidden = false
        let a = dateNext
        let b = stringTounixTimeOnlyData(dateString: a)
        let c = b - 86400
        let d = unixTimeInttoStringOnlyDate(unixTime: c)
        dateNext = d
        dateCurrent = stringTounixTimeOnlyData(dateString: d)
        dayButton.setTitle("\(d)", for: .normal)
        timeHour.removeAll()
        valueParametrs.removeAll()
        let timeCurrentString = dateNext
        let timeCurrent = stringTounixTimeOnlyData(dateString: timeCurrentString)
        let timeCurrentNextDay = timeCurrent + 86400
        for i in 0...parametrValues!.count - 1 {
            let timeString = unixTimeStringtoStringOnlyDate(unixTime: (parametrValues?[i].time)!)
            print("timeCurrentNextDay: \(timeCurrentNextDay)")
            print("timeCurrent: \(timeCurrent)")
            let time = stringTounixTimeOnlyData(dateString: timeString)
            print("time: \(time)")
            if time == timeCurrent && time < timeCurrentNextDay {
                let timeStringNew = unixTimeStringtoStringOnlyHour(unixTime: (parametrValues?[i].time)!)
                timeHour.append(timeStringNew)
                var nameParametr = 0.0
                switch name {
                case 1:
                    nameParametr = ((parametrValues?[i].parametrt)! as NSString).doubleValue
                case 2:
                    nameParametr = ((parametrValues?[i].parametrWD)! as NSString).doubleValue
                case 3:
                    nameParametr = ((parametrValues?[i].parametrWV)! as NSString).doubleValue
                case 4:
                    nameParametr = ((parametrValues?[i].parametrWM)! as NSString).doubleValue
                case 5:
                    nameParametr = ((parametrValues?[i].parametrPR)! as NSString).doubleValue
                case 6:
                    nameParametr = ((parametrValues?[i].parametrHM)! as NSString).doubleValue
                case 7:
                    nameParametr = ((parametrValues?[i].parametrRN)! as NSString).doubleValue
                case 8:
                    nameParametr = ((parametrValues?[i].parametrUV)! as NSString).doubleValue
                case 9:
                    nameParametr = ((parametrValues?[i].parametrUVI)! as NSString).doubleValue
                case 10:
                    nameParametr = ((parametrValues?[i].parametrL)! as NSString).doubleValue
                case 11:
                    nameParametr = ((parametrValues?[i].parametrLI)! as NSString).doubleValue
                case 12:
                    nameParametr = ((parametrValues?[i].parametrUpow)! as NSString).doubleValue
                case 13:
                    nameParametr = ((parametrValues?[i].parametrUext)! as NSString).doubleValue
                case 14:
                    nameParametr = ((parametrValues?[i].parametrKS)! as NSString).doubleValue
                case 15:
                    nameParametr = ((parametrValues?[i].parametrRSSI)! as NSString).doubleValue
                case 16:
                    nameParametr = ((parametrValues?[i].parametrTR)! as NSString).doubleValue
                case 17:
                    nameParametr = ((parametrValues?[i].parametrEVS)! as NSString).doubleValue
                default:
                    print("")
                }
                valueParametrs.append("\(nameParametr)")
            }
        }
        tableView.reloadData()
        viewAlpha.isHidden = true
    }
    @objc func switchImageSegmented() {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        let blackBoxGraffics = BlackBoxGraffics()
        blackBoxGraffics.name = name
        blackBoxGraffics.nameDeviceBox = nameDeviceBox
        blackBoxGraffics.parametrValues = parametrValues
        self.navigationController?.pushViewController(blackBoxGraffics, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .allButUpsideDown
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let viewControllers = navigationController?.viewControllers,
              let index = viewControllers.firstIndex(of: self) else { return }
        navigationController?.viewControllers.remove(at: index)
    }
    func stratTableView() {
        timeHour.removeAll()
        valueParametrs.removeAll()
        let timeCurrentString = dateNext
        let timeCurrent = stringTounixTimeOnlyData(dateString: timeCurrentString)
        let timeCurrentNextDay = timeCurrent + 86400
        for i in 0...parametrValues!.count - 1 {
            let timeString = unixTimeStringtoStringOnlyDate(unixTime: (parametrValues?[i].time)!)
            print("timeCurrentNextDay: \(timeCurrentNextDay)")
            print("timeCurrent: \(timeCurrent)")
            let time = stringTounixTimeOnlyData(dateString: timeString)
            print("time: \(time)")
            if time == timeCurrent && time < timeCurrentNextDay {
                let timeStringNew = unixTimeStringtoStringOnlyHour(unixTime: (parametrValues?[i].time)!)
                timeHour.append(timeStringNew)
                var nameParametr = 0.0
                switch name {
                case 1:
                    nameParametr = ((parametrValues?[i].parametrt)! as NSString).doubleValue
                case 2:
                    nameParametr = ((parametrValues?[i].parametrWD)! as NSString).doubleValue
                case 3:
                    nameParametr = ((parametrValues?[i].parametrWV)! as NSString).doubleValue
                case 4:
                    nameParametr = ((parametrValues?[i].parametrWM)! as NSString).doubleValue
                case 5:
                    nameParametr = ((parametrValues?[i].parametrPR)! as NSString).doubleValue
                case 6:
                    nameParametr = ((parametrValues?[i].parametrHM)! as NSString).doubleValue
                case 7:
                    nameParametr = ((parametrValues?[i].parametrRN)! as NSString).doubleValue
                case 8:
                    nameParametr = ((parametrValues?[i].parametrUV)! as NSString).doubleValue
                case 9:
                    nameParametr = ((parametrValues?[i].parametrUVI)! as NSString).doubleValue
                case 10:
                    nameParametr = ((parametrValues?[i].parametrL)! as NSString).doubleValue
                case 11:
                    nameParametr = ((parametrValues?[i].parametrLI)! as NSString).doubleValue
                case 12:
                    nameParametr = ((parametrValues?[i].parametrUpow)! as NSString).doubleValue
                case 13:
                    nameParametr = ((parametrValues?[i].parametrUext)! as NSString).doubleValue
                case 14:
                    nameParametr = ((parametrValues?[i].parametrKS)! as NSString).doubleValue
                case 15:
                    nameParametr = ((parametrValues?[i].parametrRSSI)! as NSString).doubleValue
                case 16:
                    nameParametr = ((parametrValues?[i].parametrTR)! as NSString).doubleValue
                case 17:
                    nameParametr = ((parametrValues?[i].parametrEVS)! as NSString).doubleValue
                default:
                    print("")
                }
                valueParametrs.append("\(nameParametr)")
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateNext = unixTimeStringtoStringOnlyDate(unixTime: (parametrValues?.last!.time)!)
        stratTableView()
        view.backgroundColor = .white
        registerTableView()
        viewModel = ViewModelBlackBoxTable()
        let customNavigationBar = createCustomNavigationBar(title: "",fontSize: screenW / 22)
        self.hero.isEnabled = true
        view.sv(customNavigationBar, backView,switchGrafficsOrTable)
        backView.addTapGesture { [self] in popVC() }
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavigationBar.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 10).isActive = true

        switchGrafficsOrTable.bottomAnchor.constraint(equalTo: customNavigationBar.bottomAnchor).isActive = true
        switchGrafficsOrTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10).isActive = true
        
        backView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        backView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10).isActive = true


        cosntrains()
        viewAlpha.isHidden = true
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(viewAlpha)
    }

    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func cosntrains() {
        
        view.sv(labelName, labelNameParametr, imageParametr, containerButtons)
        containerButtons.sv(dayButton, backGrafficsOrTable, nextGrafficsOrTable)
        
        labelName.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 20).isActive = true
        labelName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        labelNameParametr.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 1).isActive = true
        labelNameParametr.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        labelNameParametr.trailingAnchor.constraint(equalTo: imageParametr.leadingAnchor, constant: -10).isActive = true

        imageParametr.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 20).isActive = true
        imageParametr.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        imageParametr.widthAnchor.constraint(equalToConstant: 40).isActive = true

        dayButton.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
//        dayButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        dayButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        dayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dayButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        
        backGrafficsOrTable.centerYAnchor.constraint(equalTo: dayButton.centerYAnchor).isActive = true
        backGrafficsOrTable.trailingAnchor.constraint(equalTo: dayButton.leadingAnchor, constant: -10).isActive = true

        nextGrafficsOrTable.centerYAnchor.constraint(equalTo: dayButton.centerYAnchor).isActive = true
        nextGrafficsOrTable.leadingAnchor.constraint(equalTo: dayButton.trailingAnchor, constant: 10).isActive = true

        containerButtons.topAnchor.constraint(equalTo: dayButton.topAnchor).isActive = true
        containerButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: labelNameParametr.bottomAnchor,constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: containerButtons.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

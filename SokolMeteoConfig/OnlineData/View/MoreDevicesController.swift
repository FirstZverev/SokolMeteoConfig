//
//  MoreDevicesController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//
import UIKit

class MoreDevicesController : UIViewController {
    
    var tableView: UITableView!
    var a: CGFloat = 0
    var timer = Timer()
    let generator = UIImpactFeedbackGenerator(style: .light)
    var viewModel: TableViewViewModelType?
    var delegate: BMVDDelegate?
    var MoreDevicesBmvdPortVC = MoreDevicesBmvdPortController()
    let customNavigationBar = createCustomNavigationBar(title: "ДОП. УСТРОЙСТВА",fontSize: screenW / 22)

    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
    
    var emptyList: UILabel = {
        let emptyList = UILabel()
        emptyList.text = "СПИСОК БМВД ПУСТ"
//        emptyList.center.x = screenW / 2
//        emptyList.center.y = screenH / 2
        emptyList.font = UIFont(name: "FuturaPT-Light", size: 20)
        emptyList.textColor = .gray
        emptyList.translatesAutoresizingMaskIntoConstraints = false
        //        emptyList.isHidden = false
        return emptyList
    }()
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.height(screenH - (screenH / 12)).width(screenW)
        tableView.backgroundColor = .clear
        tableView.addSubview(emptyList)
        self.tableView = tableView
    }
    override func viewDidAppear(_ animated: Bool) {
        reload = 2
        delegate?.buttonTapBMVD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.tableView.reloadData()
        })
        timer =  Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (timer) in
            if Access_Allowed >= 1 {
                reload = 2
                self.delegate?.buttonTapBMVD()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if demoMode {
            countBMVD = 0
            arrayBmvdCount.removeAll()
            arrayCount.removeAll()
            for i in 0...7 {
                arrayBmvdU[countBMVD] = "\(Double.random(in: 2.8...3.7).roundToDecimal(2))"
                arrayBmvdCount["\(i)T\(0)"] = "\(Double.random(in: 21...29).roundToDecimal(2))"
                arrayBmvdCount["\(i)H\(1)"] = "\(Int.random(in: 0...5))"
                arrayBmvdCount["\(i)h\(2)"] = "\(Int.random(in: 0...5))"
                arrayBmvdCount["\(i)t\(3)"] = "\(Int.random(in: 20...30))"
                arrayBmvdCount["\(i)h\(4)"] = "\(Int.random(in: 0...5))"
                arrayBmvdCount["\(i)t\(5)"] = "\(Int.random(in: 20...30))"
                arrayBmvdCount["\(i)l\(6)"] = "\(Int.random(in: 0...5))"
                arrayBmvdR[countBMVD] = "\(Int.random(in: -70 ... -15))"
                countBMVD += 1
                arrayCount.append(i)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        reload = -1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModelMoreDevices()
        view.backgroundColor = .white
        self.hero.isEnabled = true
        createTableView()
        registerCell()
        view.sv(customNavigationBar, backView)
        backView.addTapGesture { [self] in self.popVC() }
        emptyList.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyList.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true

    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(moreDevicesCell.self, forCellReuseIdentifier: "moreDevicesCell")
        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 130))
        headerView.imageView.image = UIImage(named: "headerbg3")
        self.tableView.tableHeaderView = headerView
    }
}

extension MoreDevicesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreDevicesCell", for: indexPath) as? moreDevicesCell
        cell?.labelUbat.text = "Напряжение батареи: " + arrayBmvdU[indexPath.row] + " В"
        cell?.labelRssi.text = "Уровень радиосигнала: " + arrayBmvdR[indexPath.row] + " дБ"
        if indexPath.row == 0 {
            cell?.clipsToBounds = true
            cell?.layer.cornerRadius = 40
            cell?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        } else {
            cell?.layer.cornerRadius = 0
        }
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        return tableViewCell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if countBMVD == 0 {
            emptyList.isHidden = false
        } else {
            emptyList.isHidden = true
        }
        return countBMVD
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        generator.impactOccurred()
        UIView.animate(withDuration: 0.5) {
            let cell  = tableView.cellForRow(at: indexPath) as? moreDevicesCell
//            cell!.imageUI!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.nextImage!.tintColor = UIColor(rgb: 0xBE449E)
            cell!.label!.textColor = UIColor(rgb: 0xBE449E)
            cell!.labelUbat!.textColor = UIColor(rgb: 0xBE449E)
            cell!.labelRssi!.textColor = UIColor(rgb: 0xBE449E)
            cell?.contentView.backgroundColor = UIColor(rgb: 0xECECEC)
        }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell  = tableView.cellForRow(at: indexPath) as? moreDevicesCell
            cell!.nextImage!.tintColor = UIColor(rgb: 0x998F99)
            cell!.label!.textColor = .black
            cell!.labelUbat!.textColor = .black
            cell!.labelRssi!.textColor = .black
            cell?.contentView.backgroundColor = .white
//            cell!.imageUI!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//            cell!.label!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moreDevicesBmvdPortVC = MoreDevicesBmvdPortController()
        if indexPath.row <= arrayCount.count - 1 {
            moreDevicesBmvdPortVC.countBmvd = arrayCount[indexPath.row]
            let transition = CATransition()
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.fade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(moreDevicesBmvdPortVC, animated: false)

        }
    }
}

extension MoreDevicesController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! StretchyTableHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
        
        var offset = scrollView.contentOffset.y / 150
        print(offset)
        if offset > 1 {
            offset = 1
            customNavigationBar.alpha = offset
        } else {
            customNavigationBar.alpha = offset
        }
    }
}

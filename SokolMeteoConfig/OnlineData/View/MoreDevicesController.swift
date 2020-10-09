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
        tableView.top(screenH / 12)
        tableView.backgroundColor = .white
        self.tableView = tableView
    }
    override func viewDidAppear(_ animated: Bool) {
        reload = 2
        delegate?.buttonTapBMVD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.tableView.reloadData()
        })
        timer =  Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (timer) in
            if Access_Allowed == 1 {
                self.delegate?.buttonTapBMVD()
                self.tableView.reloadData()
            }

        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        reload = -1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModelMoreDevices()
        view.backgroundColor = .white
        let customNavigationBar = createCustomNavigationBar(title: "ДОП. УСТРОЙСТВА",fontSize: screenW / 22)
        self.hero.isEnabled = true
        createTableView()
        registerCell()
        view.sv(customNavigationBar, backView, emptyList)
        backView.addTapGesture { [self] in self.popVC() }
        emptyList.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyList.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(moreDevicesCell.self, forCellReuseIdentifier: "moreDevicesCell")
    }
    
}

extension MoreDevicesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreDevicesCell", for: indexPath) as? moreDevicesCell
        cell?.labelUbat.text = "Напряжение батареи: " + arrayBmvdU[indexPath.row] + " В"
        cell?.labelRssi.text = "Уровень радиосигнала: " + arrayBmvdR[indexPath.row] + " дБ"
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
        
        navigationController?.pushViewController(StateController(), animated: true)
    }
}

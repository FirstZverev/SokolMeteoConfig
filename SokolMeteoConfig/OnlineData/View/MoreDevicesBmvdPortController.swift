//
//  MoreDevicesBmvdPortController.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 25.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//
import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String()]
}

class MoreDevicesBmvdPortController : UIViewController {
    
    var countBmvd = 0
    var tableViewData = [cellData]()
    var tableView: UITableView!
    var a: CGFloat = 0
    var timer = Timer()
    let generator = UIImpactFeedbackGenerator(style: .light)
    var viewModel: TableViewViewModelType?
    var viewModelHide: TableViewViewModelType?
    var delegate: BMVDDelegate?
    let customNavigationBar = createCustomNavigationBar(title: "БЕСПРОВОДНОЙ МОДУЛЬ",fontSize: screenW / 22)

    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.height(screenH).width(screenW)
        tableView.backgroundColor = .clear
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
                reload = 2
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
        viewModel = ViewModelMoreDeviceBmvdPort()
        viewModelHide = ViewModelMoreDeviceBmvdPortHide()
        view.backgroundColor = .white
        self.hero.isEnabled = true
        createTableView()
        registerCell()
        view.sv(customNavigationBar, backView)
        backView.addTapGesture { [self] in self.popVC() }
        tableViewData.append(cellData(opened: true, title: "", sectionData: [""]))
        tableViewData.append(cellData(opened: true, title: "", sectionData: [""]))
        tableViewData.append(cellData(opened: true, title: "", sectionData: [""]))
        tableViewData.append(cellData(opened: true, title: "", sectionData: [""]))
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(moreDevicesBmvdPortCell.self, forCellReuseIdentifier: "moreDevicesBmvdPortCell")
        tableView.register(moreDevicesBmvdPortHideCell.self, forCellReuseIdentifier: "moreDevicesBmvdPortHideCell")

        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 130))
        headerView.imageView.image = UIImage(named: "headerbg3")
        self.tableView.tableHeaderView = headerView
    }
}

extension MoreDevicesBmvdPortController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreDevicesBmvdPortCell", for: indexPath) as? moreDevicesBmvdPortCell
            guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
            let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreDevicesBmvdPortHideCell", for: indexPath) as? moreDevicesBmvdPortHideCell
            if indexPath.section == 0 {
                cell?.label.text = ""
                cell?.imageUI.image = nil
                cell?.labelUbat.text = ""
                cell?.imageUITwo.image = nil
                cell?.labelRssi.text = ""
                cell?.labelRssiTwo.text = ""
                if let a = arrayBmvdCount["\(countBmvd)T0"] {
                    cell?.label.text = "Цифровой датчик температуры почвы"
                    cell?.imageUI.image = UIImage(named: "temperature2")
                    cell?.labelRssi.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)H0"] {
                    cell?.label.text = "Цифровой датчик влажности почвы"
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)h0"] {
                    cell?.label.text = "Аналоговый датчик влажности почвы"
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)t0"] {
                    cell?.label.text = "Аналоговый датчик температуры почвы"
                    cell?.imageUI.image = UIImage(named: "temperature2")
                    cell?.labelRssi.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)l0"] {
                    cell?.label.text = "Аналоговый датчик влажности листа"
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
                
                if let a = arrayBmvdCount["\(countBmvd)T1"] {
                    cell?.labelUbat.text = "Цифровой датчик температуры почвы"
                    cell?.imageUITwo.image = UIImage(named: "temperature2")
                    cell?.labelRssiTwo.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)H1"] {
                    cell?.labelUbat.text = "Цифровой датчик влажности почвы"
                    cell?.imageUITwo.image = UIImage(named: "intensiv2")
                    cell?.labelRssiTwo.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)h1"] {
                    cell?.labelUbat.text = "Аналоговый датчик влажности почвы"
                    cell?.imageUITwo.image = UIImage(named: "intensiv2")
                    cell?.labelRssiTwo.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)t1"] {
                    cell?.labelUbat.text = "Аналоговый датчик температуры почвы"
                    cell?.imageUITwo.image = UIImage(named: "temperature2")
                    cell?.labelRssiTwo.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)l1"] {
                    cell?.labelUbat.text = "Аналоговый датчик влажности листа"
                    cell?.imageUITwo.image = UIImage(named: "intensiv2")
                    cell?.labelRssiTwo.text = a + " %"
                }
            } else if indexPath.section == 1 {
                cell?.label.text = ""
                cell?.imageUI.image = nil
                cell?.labelUbat.text = ""
                cell?.imageUITwo.image = nil
                cell?.labelRssi.text = ""
                cell?.labelRssiTwo.text = ""
                if let a = arrayBmvdCount["\(countBmvd)T2"] {
                    cell?.label.text = "Цифровой датчик температуры почвы"
                    cell?.imageUI.image = UIImage(named: "temperature2")
                    cell?.labelRssi.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)H2"] {
                    cell?.label.text = "Цифровой датчик влажности почвы"
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)h2"] {
                    cell?.label.text = "Аналоговый датчик влажности почвы"
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)t2"] {
                    cell?.label.text = "Аналоговый датчик температуры почвы"
                    cell?.imageUI.image = UIImage(named: "temperature2")
                    cell?.labelRssi.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)l2"] {
                    cell?.label.text = "Аналоговый датчик влажности листа"
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
                
                if let a = arrayBmvdCount["\(countBmvd)T3"] {
                    cell?.labelUbat.text = "Цифровой датчик температуры почвы"
                    cell?.imageUITwo.image = UIImage(named: "temperature2")
                    cell?.labelRssiTwo.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)H3"] {
                    cell?.labelUbat.text = "Цифровой датчик влажности почвы"
                    cell?.imageUITwo.image = UIImage(named: "intensiv2")
                    cell?.labelRssiTwo.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)h3"] {
                    cell?.labelUbat.text = "Аналоговый датчик влажности почвы"
                    cell?.imageUITwo.image = UIImage(named: "intensiv2")
                    cell?.labelRssiTwo.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)t3"] {
                    cell?.labelUbat.text = "Аналоговый датчик температуры почвы"
                    cell?.imageUITwo.image = UIImage(named: "temperature2")
                    cell?.labelRssiTwo.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)l3"] {
                    cell?.labelUbat.text = "Аналоговый датчик влажности листа"
                    cell?.imageUITwo.image = UIImage(named: "intensiv2")
                    cell?.labelRssiTwo.text = a + " %"
                }
            } else if indexPath.section == 2 {
                cell?.label.text = ""
                cell?.imageUI.image = nil
                cell?.labelUbat.text = ""
                cell?.imageUITwo.image = nil
                cell?.labelRssi.text = ""
                cell?.labelRssiTwo.text = ""
                if let a = arrayBmvdCount["\(countBmvd)T4"] {
                    cell?.label.text = "Цифровой датчик температуры почвы"
                    cell?.imageUI.image = UIImage(named: "temperature2")
                    cell?.labelRssi.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)H4"] {
                    cell?.label.text = "Цифровой датчик влажности почвы"
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)h4"] {
                    cell?.label.text = "Аналоговый датчик влажности почвы"
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)t4"]{
                    cell?.label.text = "Аналоговый датчик температуры почвы"
                    cell?.imageUI.image = UIImage(named: "temperature2")
                    cell?.labelRssi.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)l4"] {
                    cell?.label.text = "Аналоговый датчик влажности листа"
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
                
                if let a = arrayBmvdCount["\(countBmvd)T5"] {
                    cell?.labelUbat.text = "Цифровой датчик температуры почвы"
                    cell?.imageUITwo.image = UIImage(named: "temperature2")
                    cell?.labelRssiTwo.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)H5"] {
                    cell?.labelUbat.text = "Цифровой датчик влажности почвы"
                    cell?.imageUITwo.image = UIImage(named: "intensiv2")
                    cell?.labelRssiTwo.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)h5"]{
                    cell?.labelUbat.text = "Аналоговый датчик влажности почвы"
                    cell?.imageUITwo.image = UIImage(named: "intensiv2")
                    cell?.labelRssiTwo.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)t5"]{
                    cell?.labelUbat.text = "Аналоговый датчик температуры почвы"
                    cell?.imageUITwo.image = UIImage(named: "temperature2")
                    cell?.labelRssiTwo.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)l5"] {
                    cell?.labelUbat.text = "Аналоговый датчик влажности листа"
                    cell?.imageUITwo.image = UIImage(named: "intensiv2")
                    cell?.labelRssiTwo.text = a + " %"
                }
            } else if indexPath.section == 3 {
                cell?.label.text = ""
                cell?.imageUI.image = nil
                cell?.labelUbat.text = ""
                cell?.imageUITwo.image = nil
                cell?.labelRssi.text = ""
                cell?.labelRssiTwo.text = ""
                if let a = arrayBmvdCount["\(countBmvd)T6"] {
                    cell?.label.text = "Цифровой датчик температуры почвы"
                    cell?.imageUI.image = UIImage(named: "temperature2")
                    cell?.labelRssi.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)H6"] {
                    cell?.label.text = "Цифровой датчик влажности почвы"
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)h6"] {
                    cell?.label.text = "Аналоговый датчик влажности почвы"
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
                if let a = arrayBmvdCount["\(countBmvd)t6"] {
                    cell?.label.text = "Аналоговый датчик температуры почвы"
                    cell?.imageUI.image = UIImage(named: "temperature2")
                    cell?.labelRssi.text = a + " °C"
                }
                if let a = arrayBmvdCount["\(countBmvd)l6"] {
                    cell?.label.text = "Аналоговый датчик влажности листа "
                    cell?.imageUI.image = UIImage(named: "intensiv2")
                    cell?.labelRssi.text = a + " %"
                }
            }
            guard let tableViewCell = cell, let viewModel = viewModelHide else { return UITableViewCell() }
            let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewData[indexPath.section].opened == true {
            self.tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .fade)
            
        } else {
            self.tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .fade)
        }
    }
}

extension MoreDevicesBmvdPortController: UIScrollViewDelegate {
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

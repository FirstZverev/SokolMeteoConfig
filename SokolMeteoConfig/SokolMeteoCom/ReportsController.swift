//
//  ReportsController.swift
//  SOKOL
//
//  Created by Володя Зверев on 13.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class ReportsController : UIViewController {
    
    var tableView: UITableView!
    let generator = UIImpactFeedbackGenerator(style: .light)
    var viewModel: ServiceModel = ServiceModel()
    let selectObectVC = SelectObectController()
    var networkManager = NetworkManager()
    let savedReportsVC = SavedFilesController()
    
    private lazy var natificationButton: UIButton = {
        let natification = UIButton()
        natification.setImage(UIImage(named: "reports"), for: .normal)
        natification.translatesAutoresizingMaskIntoConstraints = false
        natification.addTarget(self, action: #selector(naticAction), for: .touchUpInside)
        return natification
    }()
    @objc func naticAction() {
        savedReportsVC.isBackBox = false
        let navigationController = UINavigationController(rootViewController: savedReportsVC)
        navigationController.navigationBar.isHidden = true
        self.present(navigationController, animated: true)
    }
    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
    var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0xBE449E)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Выполнить отчет", for: .normal)
        button.addTarget(self, action: #selector(actionSave), for: .touchUpInside)
        return button
    }()
    
    @objc func actionSave() {
        viewAlphaAlways.isHidden = false
        let report = ReportData(id: devicesList[viewModel.tag].id!, startDate: orderDateTo, endDate: orderDateFrom)
        networkManager.networkingReport(reportData: report) { (data, error) in
            DispatchQueue.main.async {
                guard let data = data else {return}
                print("print data: \(data)")
                self.saveCSV(data: data, isShare: false)
            }
        }
    }
    func saveCSV(data: [DeviceListResult], isShare: Bool) {
//        let realmboxing = realm.objects(BoxModel.self).filter("nameDevice = %@", nameDeviceBlackBox!)
        let file = "Отчет" + " №\(viewModel.sokolTemplateInfo[1]) от \(orderDateTo) до \(orderDateFrom)"
        var contents = ""
//        contents += "\n"
        
//        for index in data {
//            if index.records?.count != 0 {
//                contents += "\(index.name!)\n"
//                for record in index.records! {
//                    contents += "\(record.date!), \(record.value!)\n"
//                }
//            }
        for index in data {
            guard let name = index.name  else {return}
            let redactName = name.replacingOccurrences(of: ",", with: " ", options: .literal, range: nil)
            contents += "\(redactName)," + "Значение,"
        }
        contents += "\n"
        var count = 0
        var countMax = 1
        for index in data {
            if index.records!.count > countMax {
                countMax = index.records!.count
            }
        }
        for _ in 0...countMax {
            for index in data {
                if index.records?.count != 0 {
                    guard let record = index.records else {   return   }
                    if index.records!.count - 1 >= count {
                        let date = convertDateFormatter(date: record[count].date!)
                        contents += "\(date), \(record[count].value!),"
                    } else {
                        contents += ", ,"
                    }
                } else {
                    contents += ", ,"
                }
            }
            count += 1
            contents += "\n"
        }
//        contents += "\n"


        WorkWithFiles.createFile(name: viewModel.sokolTemplateInfo[1], isBackBox: false) { (url) in
            let fileURL = url.appendingPathComponent(file).appendingPathExtension("csv")
            DispatchQueue.main.async {
                FileManager.default.createFile(atPath: fileURL.path, contents: Data(contents.utf8))
                    viewAlphaAlways.isHidden = true
                    self.naticAction()
            }
        }

//        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        let docURL = URL(string: documentsDirectory)!
//        let dataPath = docURL.appendingPathComponent("MyFolder")
//        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
//            do {
//                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)

        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "d MMM yyyy HH:mm"///this is what you want to convert format
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)

        return timeStamp
    }
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.height(screenH - (screenH / 12)).width(screenW)
        tableView.top(screenH / 12)
        tableView.backgroundColor = .white
        self.tableView = tableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.sokolTemplateInfo[1] == "Не выбрано" {
            saveButton.alpha = 0.5
            saveButton.isEnabled = false
        } else {
            saveButton.alpha = 1.0
            saveButton.isEnabled = true
        }
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let now = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = .current
        orderDateTo = formatter.string(from: now)
        orderDateFrom = formatter.string(from: tomorrow!)
//        var realmDevice = realm.objects(DeviceNameModel.self)
//        let a = map(realmDevice) {$0.name}
        let customNavigationBar = createCustomNavigationBar(title: "ОТЧЕТЫ",fontSize: screenW / 22)
        self.hero.isEnabled = true
        createTableView()
        registerCell()
        view.sv(customNavigationBar, backView)
        view.addSubview(saveButton)
        customNavigationBar.hero.id = "SOKOLMETEO"
        backView.addTapGesture { [self] in self.popVC() }
        
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: screenW / 1.5).isActive = true
        
        view.addSubview(natificationButton)
        
        natificationButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        natificationButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        natificationButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 - 3).isActive = true
        natificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true



    }
    
    func popVC() {
        tabBarController?.selectedIndex = 0
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SecondConfigBMVDCell.self, forCellReuseIdentifier: "SecondConfigBMVDCell")
        tableView.register(TemplatesCell.self, forCellReuseIdentifier: "TemplatesCell")

    }
    
}

extension ReportsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemplatesCell", for: indexPath) as! TemplatesCell
            cell.labelName.text = viewModel.sokolTemplateName[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondConfigBMVDCell", for: indexPath) as! SecondConfigBMVDCell
            cell.label.text = viewModel.sokolTemplateName[indexPath.row]
            cell.labelMac.text = viewModel.sokolTemplateInfo[indexPath.row]
            cell.imageUI.image = UIImage(named: "EllipseSokolName")
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sokolTemplateName.count
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        generator.impactOccurred()
//        UIView.animate(withDuration: 0.5) {
//            let cell  = tableView.cellForRow(at: indexPath) as? BlackBoxListCell
//            cell!.nextImage!.tintColor = UIColor(rgb: 0xBE449E)
//            cell!.label!.textColor = UIColor(rgb: 0xBE449E)
//            cell?.contentView.backgroundColor = UIColor(rgb: 0xECECEC)
//        }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.2) {
//            let cell  = tableView.cellForRow(at: indexPath) as? BlackBoxListCell
//            cell!.nextImage!.tintColor = UIColor(rgb: 0x998F99)
//            cell?.selectionStyle = .none
//            cell!.label!.textColor = .black
//            cell?.contentView.backgroundColor = .white
//        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            selectObectVC.viewModel = viewModel
            selectObectVC.delegate = self
            let navigationController = UINavigationController(rootViewController: selectObectVC)
            navigationController.navigationBar.isHidden = true
            self.present(navigationController, animated: true)
        }
    }
}

extension ReportsController: SelectObectDelegate {
    func selected() {
        if viewModel.sokolTemplateInfo[1] == "Не выбрано" {
            saveButton.alpha = 0.5
            saveButton.isEnabled = false
        } else {
            saveButton.alpha = 1.0
            saveButton.isEnabled = true
        }
        tableView.reloadData()
    }
}

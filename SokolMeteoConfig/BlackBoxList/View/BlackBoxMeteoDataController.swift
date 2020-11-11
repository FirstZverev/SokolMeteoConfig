//
//  BlackBoxMeteo.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 20.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import RealmSwift
import NVActivityIndicatorView

class BlackBoxMeteoDataController: UIViewController {
    
    let realm: Realm = {
        return try! Realm()
    }()
    var realmBox: Results<BoxModel>?
    var nameDeviceBlackBox: String!
    var tableView: UITableView!
    var viewModel: TableViewViewModelTypeBlackBox?
//    var timer = Timer()
    var delegate: MeteoDelegate?
    let customNavigationBar = createCustomNavigationBar(title: "",fontSize: screenW / 22)
    var indexPathCounst: IndexPath?
    
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
    lazy var alertView: SelectPush = {
        let alertView: SelectPush = SelectPush.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    lazy var alertViewAccount: AccountAlert = {
        let alertView: AccountAlert = AccountAlert.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    lazy var alertViewDelete: ConfirmationAlert = {
        let alertView: ConfirmationAlert = ConfirmationAlert.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    lazy var alertViewWarningDelete: CustomAlertWarning = {
        let alertView: CustomAlertWarning = CustomAlertWarning.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
       let view = UIVisualEffectView(effect: blurEffect)
//        view.translatesAutoresizingMaskIntoConstraints = false
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
    fileprivate lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setImage(UIImage(named: "imgPushBar"), for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(createAlert), for: .touchUpInside)
        return saveButton
    }()
    
    fileprivate lazy var save2Button: UIButton = {
        let saveButton = UIButton()
        saveButton.setImage(UIImage(named: "imgSaveBar"), for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveFile), for: .touchUpInside)
        return saveButton
    }()
    
    fileprivate lazy var save3Button: UIButton = {
        let saveButton = UIButton()
        saveButton.setImage(UIImage(named: "imgDeleteBar"), for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(deleteBlackBox), for: .touchUpInside)
        return saveButton
    }()
    
    override func loadView() {
        super.loadView()
        createTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.myOrientation = .portrait
        realmBox = realm.objects(BoxModel.self).filter("nameDevice = %@", nameDeviceBlackBox!)
    }
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func viewDidAppear(_ animated: Bool) {
//        reload = 2
//        delegate?.buttonTapMeteo()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//            self.tableView.reloadData()
//        })
//        timer =  Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (timer) in
//            self.delegate?.buttonTapMeteo()
//            self.tableView.reloadData()
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        timer.invalidate()
//        reload = -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        registerTableView()
        
        viewModel = ModelViewBlackBox()
        self.hero.isEnabled = true
        customNavigationBar.hero.id = "OnlineToMeteo"


        view.sv(
            customNavigationBar
        )
        showView()
        viewAlpha.isHidden = true
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(viewAlpha)
    }
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.height(screenH).width(screenW)
//        tableView.top(screenH / 12)
        tableView.backgroundColor = UIColor(rgb: 0xECAFCC)

        
        self.tableView = tableView
    }
    
    private func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(MeteoBlackBoxCell.self, forCellReuseIdentifier: "MeteoBlackBoxCell")
        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 120))
        let realmCheck = realm.objects(BoxModel.self).filter("nameDevice = %@", nameDeviceBlackBox!)
        headerView.labelDate.text = "\(unixTimeStringtoStringOnlyDate(unixTime: (realmCheck.first!.time!))) - \(unixTimeStringtoStringOnlyDate(unixTime: (realmCheck.last!.time!)))"
        headerView.imageView.image = UIImage(named: "headerbg")
        self.tableView.tableHeaderView = headerView
    }
    
    func showView() {
        backView.tintColor = .black
        view.addSubview(backView)
        
        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(saveButton)
        view.addSubview(save2Button)
        view.addSubview(save3Button)
        
        saveButton.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: save2Button.leadingAnchor, constant: -10).isActive = true

        save2Button.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8).isActive = true
        save2Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        save3Button.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8).isActive = true
        save3Button.leadingAnchor.constraint(equalTo: save2Button.trailingAnchor, constant: 10).isActive = true

    }
    @objc func createAlert() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setAlert()
        animateIn()
    }
    @objc func saveFile() {
        saveCSV(isShare: false)
    }
    @objc func shareFile() {
        saveCSV(isShare: false)
    }
    @objc func deleteBlackBox() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setAlertConfirmation()
        animateInConfirmation()
    }
    func createAlertAccount() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setAlertAccount()
        animateInAccount()
    }
    func saveCSV(isShare: Bool) {
        let realmboxing = realm.objects(BoxModel.self).filter("nameDevice = %@", nameDeviceBlackBox!)
        let file = "Черный ящик" + " №\(nameDeviceBlackBox!) от \(unixTimeStringtoStringFull(unixTime: (realmboxing.first!.time!))) до \(unixTimeStringtoStringFull(unixTime: realmboxing.last!.time!)).csv"
        var contents = ""
        print(realmboxing.count)
        contents += "Дата, Время, Напряжение батареи, Температура, Направление ветра, Скорость ветра, Порыв ветра, Атмосферное давление, Влажность, Интенсивность осадков, Уровень ультрафиолетового излучения, Накопленное значение ультрафиолетового излучения, Уровень освещенности, Накопленное значение видимого излучения, Накопленные события и ошибки, Уровень сигнала GSM, Напряжение внешнего источника 12V, Количество переданных сообщений, БМВД №0 Уровень сигнала, БМВД №0 Напряжение батареи, БМВД №0 Порт №1 Влажность почвы, БМВД №0 Порт №1 Температура почвы, БМВД №0 Порт №2 Влажность почвы, БМВД №0 Порт №2 Температура почвы, БМВД №0 Порт №3 Влажность почвы, БМВД №0 Порт №3 Температура почвы, БМВД №0 Порт №4 Влажность листа, БМВД №1 Уровень сигнала, БМВД №1 Напряжение батареи, БМВД №1 Порт №1 Влажность почвы, БМВД №1 Порт №1 Температура почвы, БМВД №1 Порт №2 Влажность почвы, БМВД №1 Порт №2 Температура почвы, БМВД №1 Порт №3 Влажность почвы, БМВД №1 Порт №3 Температура почвы, БМВД №1 Порт №4 Влажность листа, БМВД №2 Уровень сигнала, БМВД №2 Напряжение батареи, БМВД №2 Порт №1 Влажность почвы, БМВД №2 Порт №1 Температура почвы, БМВД №2 Порт №2 Влажность почвы, БМВД №2 Порт №2 Температура почвы, БМВД №2 Порт №3 Влажность почвы, БМВД №2 Порт №3 Температура почвы, БМВД №2 Порт №4 Влажность листа, БМВД №3 Уровень сигнала, БМВД №3 Напряжение батареи, БМВД №3 Порт №1 Влажность почвы, БМВД №3 Порт №1 Температура почвы, БМВД №3 Порт №2 Влажность почвы, БМВД №3 Порт №2 Температура почвы, БМВД №3 Порт №3 Влажность почвы, БМВД №3 Порт №3 Температура почвы, БМВД №3 Порт №4 Влажность листа, БМВД №4 Уровень сигнала, БМВД №4 Напряжение батареи, БМВД №4 Порт №1 Влажность почвы, БМВД №4 Порт №1 Температура почвы, БМВД №4 Порт №2 Влажность почвы, БМВД №4 Порт №2 Температура почвы, БМВД №4 Порт №3 Влажность почвы, БМВД №4 Порт №3 Температура почвы, БМВД №4 Порт №4 Влажность листа, БМВД №5 Уровень сигнала, БМВД №5 Напряжение батареи, БМВД №5 Порт №1 Влажность почвы, БМВД №5 Порт №1 Температура почвы, БМВД №5 Порт №2 Влажность почвы, БМВД №5 Порт №2 Температура почвы, БМВД №5 Порт №3 Влажность почвы, БМВД №5 Порт №3 Температура почвы, БМВД №5 Порт №4 Влажность листа, БМВД №6 Уровень сигнала, БМВД №6 Напряжение батареи, БМВД №6 Порт №1 Влажность почвы, БМВД №6 Порт №1 Температура почвы, БМВД №6 Порт №2 Влажность почвы, БМВД №6 Порт №2 Температура почвы, БМВД №6 Порт №3 Влажность почвы, БМВД №6 Порт №3 Температура почвы, БМВД №6 Порт №4 Влажность листа, БМВД №7 Уровень сигнала, БМВД №7 Напряжение батареи, БМВД №7 Порт №1 Влажность почвы, БМВД №7 Порт №1 Температура почвы, БМВД №7 Порт №2 Влажность почвы, БМВД №7 Порт №2 Температура почвы, БМВД №7 Порт №3 Влажность почвы, БМВД №7 Порт №3 Температура почвы, БМВД №7 Порт №4 Влажность листа\n"
        for i in 0...realmboxing.count - 1 {
            contents += "\(unixTimeStringtoStringOnlyDate(unixTime: realmboxing[i].time!)),"
            contents += "\(unixTimeStringtoStringOnlySecond(unixTime: realmboxing[i].time!)),"
            contents += "\(realmboxing[i].parametrUpow ?? "-"),"
            contents += "\(realmboxing[i].parametrt ?? "-"),"
            contents += "\(realmboxing[i].parametrWD ?? "-"),"
            contents += "\(realmboxing[i].parametrWV ?? "-"),"
            contents += "\(realmboxing[i].parametrWM ?? "-"),"
            contents += "\(realmboxing[i].parametrPR ?? "-"),"
            contents += "\(realmboxing[i].parametrHM ?? "-"),"
            contents += "\(realmboxing[i].parametrRN ?? "-"),"
            contents += "\(realmboxing[i].parametrUV ?? "-"),"
            contents += "\(realmboxing[i].parametrUVI ?? "-"),"
            contents += "\(realmboxing[i].parametrL ?? "-"),"
            contents += "\(realmboxing[i].parametrLI ?? "-"),"
            contents += "\(realmboxing[i].parametrEVS ?? "-"),"
            contents += "\(realmboxing[i].parametrRSSI ?? "-"),"
            contents += "\(realmboxing[i].parametrUext ?? "-"),"
            contents += "\(realmboxing[i].parametrTR ?? "-")\n"
        }
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileURL = dir.appendingPathComponent(file)
        var filesToShare = [Any]()
        do {
            try contents.write(to: fileURL, atomically: true, encoding: .utf8)
            
            if isShare {
                filesToShare.append(fileURL)
            
                let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            } else {
                self.showToast(message: "Запись прошла успешно " + " \(file)", seconds: 1.0)
            }
        }
        catch {
            print("Error: \(error)")
            self.showToast(message: "Error", seconds: 1.0)
            
        }
    }
}

extension BlackBoxMeteoDataController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
        if indexPath.row != 0 {
            let checkToZero = realmBox?.filter("\((viewModel?.funcMenuMain()[indexPath.row].nameParametr)!) != nil")
            if checkToZero?.count != 0 {
                let blackBoxGraffics = BlackBoxGraffics()
                blackBoxGraffics.name = indexPath.row
                blackBoxGraffics.nameDeviceBox = nameDeviceBlackBox
                blackBoxGraffics.parametrValues = realmBox?.filter("\((viewModel?.funcMenuMain()[indexPath.row].nameParametr)!) != nil")
                navigationController?.pushViewController(blackBoxGraffics, animated: true)
            }
            //        } else if indexPath.row == 0 {
            //            navigationController?.pushViewController(TabBarController(), animated: true)
            //        }
        }
    }
}

extension BlackBoxMeteoDataController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeteoBlackBoxCell", for: indexPath) as? MeteoBlackBoxCell
        cell?.selectionStyle = .none
        if viewModel?.funcMenuMain()[indexPath.row].nameParametr != "" {
            let a = realmBox?.filter("\((viewModel?.funcMenuMain()[indexPath.row].nameParametr)!) != nil")
            cell?.labelTwo?.text = "\(a!.count)"
            if realmBox?.count != a!.count {
                cell?.nextImage.image = UIImage(named: "warning")
                cell?.nextImage.addTapGesture { [self] in
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    setAlertWarning(string: "\((cell?.label?.text)!)")
                    animateInWarning()
                }
            } else {
                cell?.nextImage.image = UIImage(named: "message")
                cell?.nextImage.addTapGesture {
                    print("print2")
                }
            }

        }
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        if indexPath.row == 0 {
            indexPathCounst = indexPath
            cell?.clipsToBounds = true
            cell?.layer.cornerRadius = 40
            cell?.labelTwo?.textColor = .white
            cell?.saveButton?.isHidden = false
            cell?.saveButton?.addTarget(self, action: #selector(createAlert), for: .touchUpInside)
            cell?.save2Button?.isHidden = false
            cell?.save2Button?.addTarget(self, action: #selector(saveFile), for: .touchUpInside)
            cell?.save3Button?.isHidden = false
            cell?.save3Button?.addTarget(self, action: #selector(deleteBlackBox), for: .touchUpInside)

            cell?.nextImage.isHidden = true
            cell?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        } else {
            cell?.layer.cornerRadius = 0
            cell?.labelTwo?.textColor = .black
            cell?.saveButton?.isHidden = true
            cell?.save2Button?.isHidden = true
            cell?.save3Button?.isHidden = true
            cell?.nextImage.isHidden = false
        }
        tableViewCell.viewModel = cellViewModel

        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            UIView.animate(withDuration: 0.5) {
                let cell  = tableView.cellForRow(at: indexPath) as? MeteoBlackBoxCell
                //            cell!.nextImage!.tintColor = UIColor(rgb: 0xBE449E)
                cell!.label!.textColor = UIColor(rgb: 0xBE449E)
                cell?.contentView.backgroundColor = UIColor(rgb: 0xECECEC)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            UIView.animate(withDuration: 0.2) {
                let cell  = tableView.cellForRow(at: indexPath) as? MeteoBlackBoxCell
                //            cell!.nextImage!.tintColor = UIColor(rgb: 0x998F99)
                cell!.label!.textColor = .black
                cell?.contentView.backgroundColor = .white
            }
        }
    }
}

extension BlackBoxMeteoDataController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! StretchyTableHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
        let offset = (scrollView.contentOffset.y - 92) / 3
        print(offset)
        if offset > 1 {
//            offset = 1
//            cell?.saveButton?.alpha = offset - 1
//            cell?.saveButton?.image = UIImage(named: "imgPushBar")
//            cell?.saveButton?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            if offset > 4 {
                customNavigationBar.alpha = offset - 4
            }
            saveButton.alpha = offset
            save2Button.alpha = offset
            save3Button.alpha = offset
        } else {
//            let cell = self.tableView.cellForRow(at: indexPathCounst!) as? MeteoBlackBoxCell
            if -offset / 5 + 1 >= 1.0 {
//                cell?.saveButton?.transform = CGAffineTransform(scaleX: 1, y: 1)
//                cell?.save2Button?.transform = CGAffineTransform(scaleX: 1, y: 1)
//                cell?.save3Button?.transform = CGAffineTransform(scaleX: 1, y: 1)

//                cell?.saveButton?.alpha = -offset

            } else {
//                cell?.saveButton?.transform = CGAffineTransform(scaleX: -offset / 5 + 1, y: -offset / 5 + 1)
//                cell?.save2Button?.transform = CGAffineTransform(scaleX: -offset / 5 + 1, y: -offset / 5 + 1)
//                cell?.save3Button?.transform = CGAffineTransform(scaleX: -offset / 5 + 1, y: -offset / 5 + 1)

//                cell?.saveButton?.alpha = -offset
            }
            customNavigationBar.alpha = 0
            saveButton.alpha = offset
            save2Button.alpha = offset
            save3Button.alpha = offset
        }
    }
}


//
//  BlackBoxTable.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 06.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class BlackBoxTable: UIViewController {
    
    var name: Int!
    var nameDeviceBox: String!

    var viewModel: TableViewViewModelType?

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
        button.setTitle("08.09.2020", for: .normal)
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
        image.image = UIImage(named: ViewModelMeteoData().menuMain[name].image!)
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
    @objc func switchImageSegmented() {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        let blackBoxGraffics = BlackBoxGraffics()
        blackBoxGraffics.name = name
        blackBoxGraffics.nameDeviceBox = nameDeviceBox
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func cosntrains() {
        
        view.sv(labelName, labelNameParametr, imageParametr, containerButtons)
        containerButtons.sv(dayButton)
        
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

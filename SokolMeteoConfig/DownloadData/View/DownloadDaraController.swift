//
//  DownloadDaraController.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 27.10.2020.
//  Copyright © 2020 zverev. All rights reserved.

import UIKit
import Alamofire
import MobileCoreServices
import RealmSwift

struct ModelDate {
    var name: String
    var date: String
    var dateMin: String
    var time: Int
    var start: String?
    var end: String?
    var state: String?
    var sentTime: String?

}

class DownloadDaraController: UIViewController {
    
    let realm: Realm = {
        return try! Realm()
    }()
    let customNavigationBar = createCustomNavigationBar(title: "ВЫГРУЖЕННЫЕ ДАННЫЕ",fontSize: screenW / 22)
    var tableView: UITableView!
    var dateCount: [ModelDate] = []
    var dictionary: [String : [ModelDate]] = [:]
    var countDateTime: [String] = []
    
    var emptyList: UILabel = {
        let emptyList = UILabel()
        emptyList.text = "У ВАС ЕЩЕ НЕТ ЗАПИСЕЙ"
//        emptyList.center.x = screenW / 2
//        emptyList.center.y = screenH / 2
        emptyList.font = UIFont(name: "FuturaPT-Light", size: screenW / 24)
        emptyList.textColor = .gray
        emptyList.translatesAutoresizingMaskIntoConstraints = false
//        emptyList.isHidden = false
        return emptyList
    }()
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        backView.hero.id = "backView"
        return backView
    }()
    fileprivate lazy var accountButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconExit"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionAcccountButton), for: .touchUpInside)
        return button
    }()
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .purple
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }

    override func loadView() {
        super.loadView()
        createTableView()
        registerTableView()
        
    }
    @objc func actionAcccountButton() {
        self.navigationController?.popViewController(animated: true)
    }
    func fetchFilms() {
        let realmCheck = realm.objects(AccountModel.self)
        let urlMain = "http://185.27.193.112:8004/"
        let urlString = urlMain + "/data?credentials=\(base64Encoded(email: realmCheck[0].user!, password: realmCheck[0].password!))&page=0&count=100"
        
        let request = AF.request(urlString)
            .validate()
            .responseDecodable(of: Network.self) { (response) in
//                guard let network = response.value else {return}
//                print(network.timestamp!)
            }
        // 2
        request.responseDecodable(of: Network.self) { [self] (response) in
          guard let films = response.value else { return }
            self.dateCount.removeAll()
            self.dictionary.removeAll()
            self.countDateTime.removeAll()
            guard films.result != nil else {return}
            for i in 0...films.result!.count - 1 {
                self.dateCount.append(ModelDate(name: (films.result?[i].station)!, date: unixTimetoStringOnlyDate(unixTime: (films.result?[i].created)!), dateMin: unixTimetoString(unixTime: (films.result?[i].created)!), time: 1, start: unixTimetoStringOnlyDate(unixTime: (films.result?[i].start)!), end: unixTimetoStringOnlyDate(unixTime: (films.result?[i].end)!), state: films.result?[i].state, sentTime: unixTimetoString(unixTime: (films.result?[i].sent) ?? 0)))
                if self.countDateTime.contains(unixTimetoStringOnlyDate(unixTime: (films.result?[i].created)!)) {} else {
                self.countDateTime.append(unixTimetoStringOnlyDate(unixTime: (films.result?[i].created)!))
                }
            }
            self.dictionary = Dictionary(grouping: self.dateCount, by: { $0.date })
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            print("HiTap")
            fetchFilms()
        } else {
            showToast(message: "Проверьте соединение", seconds: 1.0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.sv(
            customNavigationBar, accountButton
        )
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        showView()
        emptyList.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyList.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true

//        pushFileServer()
    }
    
    func showView() {
        backView.tintColor = .black
        view.addSubview(backView)
        backView.addTapGesture {
            self.navigationController?.popViewController(animated: true)
        }
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavigationBar.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0).isActive = true
        
        accountButton.bottomAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: -5).isActive = true
        accountButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true

    }
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.indicatorStyle = .black
        self.view.sv(tableView)
//        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
//        tableView.top(screenH / 12)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.refreshControl = refreshControl
        tableView.sectionHeaderHeight = 50
        tableView.allowsSelection = false
        tableView.addSubview(emptyList)
        self.tableView = tableView
    }
    @objc func refresh(sender:AnyObject) {
        if Reachability.isConnectedToNetwork(){
            fetchFilms()
        } else {
            showToast(message: "Проверьте соединение", seconds: 1.0)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func pushFileServer() {
        let str =
            "#L#867157048456594;111\n#B#\n020820;000000;5547.0117;N;05641.4668;E;0;0;235;6;55;12;0;1497.00,9956.00;NA;Upow:2:4.02,t:2:14.97,WD:1:88,WV:2:1.13,WV2:2:3.79,PR:1:995,HM:1:55,RN:2:0.0,UF:2:0.00,TP:1:30,TR:1:293,V:1:109|\n030820;000000;5547.0117;N;05641.4668;E;0;0;235;6;55;12;0;1497.00,9956.00;NA;Upow:2:4.02,t:2:14.97,WD:1:88,WV:2:1.13,WV2:2:3.79,PR:1:995,HM:1:55,RN:2:0.0,UF:2:0.00,TP:1:30,TR:1:293,V:1:109|\n"
        let fileURL = getDocumentsDirectory().appendingPathComponent("output.txt")

        do {
            try str.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        
        // generate boundary string using a unique string
        let boundary = UUID().uuidString
                 
        // Set the URLRequest to POST and to the specified URL
        let urlMain = "http://185.27.193.112:8004"
        let urlString = urlMain + "/data?credentials=c2VyZWdhMzE5NzVAZ21haWwuY29tOjEyMzQ1Njc4&station=Sokol-M_348&start=1596326400000&end=1596412800000"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
//        request.addValue("Bearer \(yourAuthorizationToken)", forHTTPHeaderField: "Authorization")
                 
        // Content-Type is multipart/form-data, this is the same as submitting form data with file upload
        // in a web browser
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                 
        let fileName = fileURL.lastPathComponent
        let mimetype = "text/plain"
        let paramName = "file"
        let fileData = try? Data(contentsOf: fileURL)
        var data = Data()
        // Add the file data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        data.append(fileData!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        // do not forget to set the content-length!
        print("data: \(data)")
        print("data: \(request)")
        request.httpBody = data
        request.setValue(String(data.count), forHTTPHeaderField: "Content-Length")
        let session = URLSession.shared
        let uploadTask = session.uploadTask(with: request as URLRequest, from: data,
                                            completionHandler: { (responseData, response, error) in
                                                
                                                // Check on some response headers (if it's HTTP)
                                                if let httpResponse = response as? HTTPURLResponse {
                                                    switch httpResponse.statusCode {
                                                    case 200..<300:
                                                        print("Success")
                                                    case 400..<500:
                                                        print("Request error")
                                                    case 500..<600:
                                                        print("Server error")
                                                    case let otherCode:
                                                        print("Other code: \(otherCode)")
                                                    }
                                                }
                                                
                                                // Do something with the response data
                                                if let
                                                    responseData = responseData,
                                                   let responseString = String(data: responseData, encoding: String.Encoding.utf8) {
                                                    print("Server Response:")
                                                    print(responseString)
                                                }
                                                
                                                // Do something with the error
                                                if let error = error {
                                                    print(error.localizedDescription)
                                                }
                                            })
        
        uploadTask.resume()
    }
    
}

extension DownloadDaraController: UITableViewDelegate, UITableViewDataSource {
    
    private func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(CellMain.self, forCellReuseIdentifier: "CellMain")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionary[countDateTime[section]]!.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if dictionary.count == 0 {
            emptyList.isHidden = false
        } else {
            emptyList.isHidden = true
        }
        return dictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMain", for: indexPath) as? CellMain
        cell?.deviceName?.text = (dictionary[countDateTime[indexPath.section]]?[indexPath.row].name)!
        cell?.dateLabel?.text = (dictionary[countDateTime[indexPath.section]]?[indexPath.row].start)! + " - " + (dictionary[countDateTime[indexPath.section]]?[indexPath.row].end)!
        let stringState = (dictionary[countDateTime[indexPath.section]]?[indexPath.row].state)!
        if stringState == "SENT" {
            cell?.stateLabel?.text = "Отправлено в " + (dictionary[countDateTime[indexPath.section]]?[indexPath.row].sentTime)!
            cell?.imageUI?.image = UIImage(named: "doneData")
            cell?.stateLabel?.textColor = UIColor(rgb: 0x01AC5A)
        } else if stringState == "FAULT" {
            cell?.stateLabel?.text = "Ошибка"
            cell?.imageUI?.image = UIImage(named: "status_error")
            cell?.stateLabel?.textColor = .red
        } else {
            cell?.stateLabel?.text = "В процессе"
            cell?.imageUI?.image = UIImage(named: "restoreData")
            cell?.stateLabel?.textColor = UIColor(rgb: 0xF7B801)
        }
        cell?.timeLabel?.text =  (dictionary[countDateTime[indexPath.section]]?[indexPath.row].dateMin)!
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UIButton()
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        formatter.timeZone = .current
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let formatteddate = formatter.string(from: time as Date)
        let formattedYesterday = formatter.string(from: yesterday)
        var timeLabel = countDateTime[section]
        if timeLabel == formatteddate {
            timeLabel = "Сегодня"
            label.backgroundColor = UIColor(rgb: 0xBE449E)
        } else if timeLabel == formattedYesterday {
            timeLabel = "Вчера"
            label.backgroundColor = UIColor(rgb: 0xD4D4D4)
        } else {
            label.backgroundColor = UIColor(rgb: 0xD4D4D4)
        }
        label.setTitle(" \(timeLabel) ", for: .normal)
        label.titleLabel?.numberOfLines = 0
        label.layer.cornerRadius = 15
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: screenW / 3).isActive = true
        return headerView
    }
}

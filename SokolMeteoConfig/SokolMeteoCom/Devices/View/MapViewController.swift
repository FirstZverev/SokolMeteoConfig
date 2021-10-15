//
//  MapViewController.swift
//  SOKOL
//
//  Created by Володя Зверев on 11.12.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import YandexMapsMobile

class MapViewController : UIViewController {
    
    let viewModel : ServiceModel = ServiceModel()
    var mapView: YMKMapView = {
        var mapView = YMKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
        
    }()

    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        backView.hero.id = "backView"
        return backView
    }()
  
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        guard let select = selectItem,
              let latitude: Double = Double(devicesList[select].latitude!),
              let longitude: Double = Double(devicesList[select].longitude!) else { return }
        mapView.mapWindow.map.move(with: YMKCameraPosition(target: YMKPoint(latitude: latitude, longitude: longitude), zoom: 15, azimuth: 0, tilt: 0), animationType: YMKAnimation(),
                                   cameraCallback: nil)
        let mapObjects = mapView.mapWindow.map.mapObjects
        let placemark = mapObjects.addPlacemark(with: YMKPoint(latitude: latitude, longitude: longitude))
        
        placemark.opacity = 1.0
        placemark.isDraggable = false
        placemark.setIconWith(UIImage(named:"StickerMap")!)
//        placemarkSave = placemark
//        mapObjectsSave = mapObjects
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
//        mapObjectsSave.remove(with: placemarkSave)
        mapView.mapWindow.map.mapObjects.clear()
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        var realmDevice = realm.objects(DeviceNameModel.self)
//        let a = map(realmDevice) {$0.name}
        let customNavigationBar = createCustomNavigationBar(title: "КАРТА",fontSize: screenW / 22)
        self.hero.isEnabled = true
        mapView.hero.id = "YandexMap"

        view.sv(mapView,customNavigationBar, backView)
        customNavigationBar.hero.id = "SOKOLMETEO"
        backView.addTapGesture { [self] in self.popVC() }
        
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: (screenH / 12)).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
    
    func popVC() {
//        viewModel.actionBack(nav: self.navigationController)
        dismiss(animated: true)
    }
}

//
//  ConfiguratorSecondController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 16.06.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class ConfiguratorSecondController : UIViewController {
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customNavigationBar = createCustomNavigationBar(title: "ДОП. ДАТЧИКИ",fontSize: 16.0)
        self.hero.isEnabled = true
        view.sv(customNavigationBar)
        view.addSubview(backView)
        backView.addTapGesture { [self] in self.popVC() }
        
        view.addSubview(collectionView)

        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12 + 10).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: screenH - screenH / 12).isActive = true
        
        registerCell()
    }
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerCell() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SecondConfigCell.self, forCellWithReuseIdentifier: "SecondConfigCell")
    }
    
    
}

extension ConfiguratorSecondController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondConfigCell", for: indexPath) as! SecondConfigCell
        cell.label.text = numberBMVD[indexPath.row].name
        cell.imageUI.image = UIImage(named: numberBMVD[indexPath.row].image)
        cell.content.alpha = CGFloat(numberBMVD[indexPath.row].alpha!)
        cell.isUserInteractionEnabled = numberBMVD[indexPath.row].isEnabled!
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberBMVD.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(screenW / 2 - 5), height: CGFloat(100))
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        generator.impactOccurred()
        UIView.animate(withDuration: 0.2) {
            let cell  = collectionView.cellForItem(at: indexPath) as? SecondConfigCell
            cell!.content!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.imageUI!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.label!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell!.content?.backgroundColor = UIColor(rgb: 0xF8F8FB)
            cell!.content?.layer.shadowRadius = 5.0
            cell!.content?.layer.shadowOpacity = 0.8
            cell!.content?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell  = collectionView.cellForItem(at: indexPath) as? SecondConfigCell
            cell!.content!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell!.imageUI!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell!.label!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell!.content?.backgroundColor = .white
            cell!.content?.layer.shadowRadius = 3.0
            cell!.content?.layer.shadowOpacity = 0.1
            cell!.content?.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)

        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ConfiguratorBMVDSecondController(), animated: true)
    }
}

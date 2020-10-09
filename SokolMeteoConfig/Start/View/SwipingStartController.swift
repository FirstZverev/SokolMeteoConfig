//
//  File.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 01.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import AdvancedPageControl

class SwipingStartController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var offSet: CGFloat = 1
    var width: CGFloat = screenW
    fileprivate lazy var nextButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(rgb: 0xBE449E)
        view.layer.cornerRadius = 15
        view.setImage(UIImage(named: "next"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.addTarget(self, action: #selector(nextTap), for: .touchUpInside)
        return view
    }()
    
    fileprivate lazy var blops: UIImageView = {
        let blops = UIImageView(image: UIImage(named: "Blops"))
        blops.translatesAutoresizingMaskIntoConstraints = false
        blops.transform = CGAffineTransform(translationX: CGFloat.pi/4 + collectionView.contentOffset.x / 10, y: CGFloat.pi/4 + -collectionView.contentOffset.x / 2).concatenating(CGAffineTransform(rotationAngle: CGFloat.pi/4 + collectionView.contentOffset.x / 800))
        return blops
    }()
    
    fileprivate lazy var logoStart: UIImageView = {
        let logoStart = UIImageView(image: UIImage(named: "logoStart"))
        logoStart.alpha = 0.0
        logoStart.translatesAutoresizingMaskIntoConstraints = false
        return logoStart
    }()
    
    fileprivate lazy var pageControl: AdvancedPageControlView = {
        let pageControl = AdvancedPageControlView()
        pageControl.drawer = WormDrawer(numberOfPages: 4, height: 12, width: 12, space: 12, raduis: 12, currentItem: 0,indicatorColor: UIColor(rgb: 0xBE449E), dotsColor: UIColor(rgb: 0xC4C4C4), isBordered: false)
        pageControl.backgroundColor = .clear
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInsetAdjustmentBehavior = .never
        view.addSubview(logoStart)
        view.sendSubviewToBack(logoStart)
        view.addSubview(blops)
        view.sendSubviewToBack(blops)
        collectionView?.backgroundColor = .clear
        collectionView?.register(SwipeStartCell.self, forCellWithReuseIdentifier: "SwipeStartCell")
        collectionView.isPagingEnabled = true
        view.backgroundColor = .white
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 40).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        blops.topAnchor.constraint(equalTo: view.topAnchor,constant: -54).isActive = true
        blops.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -180).isActive = true
        logoStart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoStart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func nextTap() {
//        collectionView?.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: .right)
//        navigationController?.pushViewController(StartViewController(), animated: true
        let nextItemNext: Int = Int(pageControl.drawer.currentItem) + 1
        print(nextItemNext)
        print(pageControl.drawer.numberOfPages)
        if nextItemNext == pageControl.drawer.numberOfPages {
            DispatchQueue.main.async {
                self.navigationController?.view.isUserInteractionEnabled = false
                UIView.animate(withDuration: 7.0, animations: { [self] in
                    blops.transform = CGAffineTransform(translationX: 0, y: 500)
                })
            }
            UIView.animate(withDuration: 1.0, animations: { [self] in
                pageControl.alpha = 0.0
                nextButton.alpha = 0.0
                logoStart.alpha = 0.0
            }) { [self] (_) in
                UIView.animate(withDuration: 1.0, animations: { [self] in
                    logoStart.alpha = 1.0
                }) { [self] (_) in
                    UIView.animate(withDuration: 1.0, animations: { [self] in
                        logoStart.alpha = 0.0
                    }) { [self] (_) in
                        UIView.animate(withDuration: 1.0, animations: { [self] in
                            logoStart.alpha = 1.0
                        }) { [self] (_) in
                            let transition = CATransition()
                            logoStart.alpha = 0.0
                            transition.duration = 2.35
                            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            transition.type = CATransitionType.fade
                            self.navigationController?.view.layer.add(transition, forKey: nil)
                            self.navigationController?.pushViewController(StartViewController(), animated: false)
                        }
                    }
                }
            }
        } else {
            collectionView.scrollToItem(at: IndexPath(row: nextItemNext, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwipeStartCell", for: indexPath) as! SwipeStartCell
        cell.backgroundColor = .clear
        print(indexPath)
//        cell.imageUI.image = configModelStartSwipe[indexPath.row].image
        cell.imageHumanUI.image = configModelStartSwipe[indexPath.row].imageHuman
        cell.label.text = configModelStartSwipe[indexPath.row].text
        if indexPath.row == 3 {
            cell.textView.isHidden = true
        } else {
            cell.textView.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        offSet = scrollView.contentOffset.x
        width = scrollView.frame.width
        pageControl.setCurrentItem(offset: CGFloat(offSet),width: CGFloat(width))
        blops.transform = CGAffineTransform(translationX: CGFloat.pi/4 + scrollView.contentOffset.x / 10, y: CGFloat.pi/4 + -scrollView.contentOffset.x / 2).concatenating(CGAffineTransform(rotationAngle: CGFloat.pi/4 + scrollView.contentOffset.x / 800))
        logoStart.alpha = CGFloat.pi / 20 + scrollView.contentOffset.x / 1700
    }
}

//
//  RegisterSokolMeteoController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 10.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import WebKit

class RegisterSokolMeteoController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        backView.tintColor = .black
        return backView
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.color = .purple
        activity.startAnimating()
        return activity
    }()
    var customNavigationBar = CustomNavigationView()

    let url = "https://sokolmeteo.com/login"

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidLoad() {
        customNavigationBar = createCustomNavigationBar(title: "РЕГИСТРАЦИЯ НА СОКОЛ МЕТЕО", fontSize: screenW / 22)
        activityIndicator.center = view.center
        view.addSubview(webView)
        view.addSubview(customNavigationBar)
        webView.navigationDelegate = self
        view.addSubview(activityIndicator)
        view.addSubview(backView)
        backView.addTapGesture{ [self] in
            self.navigationController?.popViewController(animated: true)
        }
        activityIndicator.startAnimating()
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)

    }
    func updateTitle(title: String) {
        customNavigationBar.title = "\(title)"

    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if webView.isLoading {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            } else {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
                
            }
        }
        if keyPath == "title" {
            title = webView.title
            updateTitle(title: title!)
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print(#function)
    }
    
}


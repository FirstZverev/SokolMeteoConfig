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
    var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.color = .purple
        activity.startAnimating()
        return activity
    }()
    var customNavigationBar = CustomNavigationView()

    let url = "https://sokolmeteo.com/login"

    override func viewDidLoad() {
        customNavigationBar = createCustomNavigationBar(title: "МЕНЮ", fontSize: screenW / 22)
        activityIndicator.center = view.center
        view.addSubview(webView)
        view.addSubview(customNavigationBar)
        webView.navigationDelegate = self
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
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


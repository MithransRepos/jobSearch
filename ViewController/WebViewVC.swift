//
//  WebViewVC.swift
//  jobSearch
//
//  Created by MithranN on 09/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit
import WebKit
class WebViewVC: BaseViewController, WKNavigationDelegate, WKUIDelegate {
    let webView: WKWebView = WKWebView()
    let urlRequest: URLRequest
    
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addViews() {
        view.addSubview(webView)
        super.addViews()
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        webView.set(.fillSuperView(self.view))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       activityIndicator.stopAnimating()
    }
    
}

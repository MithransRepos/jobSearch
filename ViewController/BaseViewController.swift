//
//  BaseViewController.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let tableView: UITableView  = UITableView()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    var apiCallInProgess: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setConstraints()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func addViews() {
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
    }
    
    func setConstraints() {
        self.activityIndicator.center = view.center
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
    }
    
    func showLoaderForLoadMore() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 44)
        spinner.startAnimating()
        tableView.tableFooterView = spinner
    }
    
    func hideLoaderForLoadMore() {
        tableView.tableFooterView = UIView()
    }
    
    
    func apiCallInProgress() {
        apiCallInProgess = true
        activityIndicator.startAnimating()
        tableView.isHidden = true
    }
    
    func apiCallCompleted() {
        apiCallInProgess = false
        tableView.isHidden = false
        activityIndicator.stopAnimating()
        hideLoaderForLoadMore()
    }
    
    
    @objc private func keyboardWillAppear(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            keyboardWillAppear(withKeyboardHeight: keyboardHeight)
        }
    }
    
    func keyboardWillAppear(withKeyboardHeight: CGFloat) {
        // can override in sub class
    }
    
    @objc func keyboardWillDisappear() {
        // can override in sub class
    }
    
} 

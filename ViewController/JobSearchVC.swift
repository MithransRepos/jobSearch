//
//  JobSearchVC.swift
//  jobSearch
//
//  Created by MithranN on 09/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit

public protocol JobSearchVCDelegate: class {
    func didTapSearchButton(location: String?, searchText: String?)
}

class JobSearchVC: BaseViewController {
    
    public var searchText: String?
    public var locationText: String?
    
    weak var delegate: JobSearchVCDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Job search"
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "powered by zip recuriters"
        return label
    }()
    
    private let locationSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Location ex: San francisco"
        return searchBar
    }()
    
    private let textSearchBar: UISearchBar  = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Search text ex: Developer, Marketing, etc"
        return searchBar
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.backgroundColor = .link
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        self.textSearchBar.text = searchText
        self.locationSearchBar.text = locationText
    }
    
    override func addViews() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(locationSearchBar)
        view.addSubview(textSearchBar)
        view.addSubview(searchButton)
    }
    
    override func setConstraints() {
        titleLabel.set(.top(view, Padding.p12), .sameLeadingTrailing(view, Padding.p12))
        subtitleLabel.set(.below(titleLabel), .sameLeadingTrailing(view, Padding.p12))
        textSearchBar.set(.below(subtitleLabel, Padding.p12), .sameLeadingTrailing(view, Padding.p12))
        locationSearchBar.set(.below(textSearchBar), .sameLeadingTrailing(view, Padding.p12))
        searchButton.set(.below(locationSearchBar, Padding.p12), .sameLeadingTrailing(view, Padding.p12))
    }
    
    
    @objc func searchButtonTapped() {
        if locationSearchBar.text?.isEmpty ?? true && textSearchBar.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Error", message: "You have enter either location or search for job description", preferredStyle:  .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        delegate?.didTapSearchButton(location: locationSearchBar.text, searchText: textSearchBar.text)
    }
}

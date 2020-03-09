//
//  JobSearchVC.swift
//  jobSearch
//
//  Created by MithranN on 09/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit
import GooglePlaces

public protocol JobSearchVCDelegate: class {
    func didTapSearchButton(_ vc: UIViewController)
}

class JobSearchVC: BaseViewController {
    
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
    
    private let daysAgo = Array(0...20)
    
    private let postedDayAgo = UIPickerView()
    
    private let searchRequestParam: ApiRequestParam
    
    init(searchRequestParam: ApiRequestParam) {
        self.searchRequestParam = searchRequestParam
        super.init(nibName: nil, bundle: nil)
        GMSPlacesClient.provideAPIKey(NetworkConstants.GoogleApiKey)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        postedDayAgo.delegate = self
        postedDayAgo.dataSource = self
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        locationSearchBar.text = searchRequestParam.location
        textSearchBar.text = searchRequestParam.searchText
        postedDayAgo.selectRow(searchRequestParam.daysAgo ?? 0, inComponent: 1, animated: false)
        locationSearchBar.delegate = self
    }
    
    override func addViews() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(locationSearchBar)
        view.addSubview(textSearchBar)
        view.addSubview(searchButton)
        view.addSubview(postedDayAgo)
    }
    
    override func setConstraints() {
        titleLabel.set(.top(view, Padding.p12), .sameLeadingTrailing(view, Padding.p12))
        subtitleLabel.set(.below(titleLabel), .sameLeadingTrailing(view, Padding.p12))
        textSearchBar.set(.below(subtitleLabel, Padding.p12), .sameLeadingTrailing(view, Padding.p12))
        locationSearchBar.set(.below(textSearchBar), .sameLeadingTrailing(view, Padding.p12))
        postedDayAgo.set(.below(locationSearchBar), .sameLeadingTrailing(view, Padding.p12), .height(60))
        searchButton.set(.below(postedDayAgo, Padding.p12), .sameLeadingTrailing(view, Padding.p12))
        
    }
    
    private func openGoogleAutoComplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        if let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue)) {
        autocompleteController.placeFields = fields
        }

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc func searchButtonTapped() {
        if locationSearchBar.text?.isEmpty ?? true && textSearchBar.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Error", message: "You have enter either location or search for job description", preferredStyle:  .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        searchRequestParam.location = locationSearchBar.text
        searchRequestParam.searchText = textSearchBar.text
        searchRequestParam.daysAgo = postedDayAgo.selectedRow(inComponent: 1) > 0 ? postedDayAgo.selectedRow(inComponent: 1) : nil
        delegate?.didTapSearchButton(self)
    }
}
extension JobSearchVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locationSearchBar.text = place.name
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
}

extension JobSearchVC: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        openGoogleAutoComplete()
        return false
    }

}

extension JobSearchVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { return 1 }
        return daysAgo.count
    }
    
    private func getTextForPicker(component: Int, row: Int) -> String?{
        if component == 0 { return "Posted on" }
        guard let item =  daysAgo[safeIndex: row] else {
            return nil
        }
        if row == 0 { return "Select"}
        return "\(item) day(s) ago"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = getTextForPicker(component: component, row: row)
        label.textAlignment = .center
        return label
    }
    
}

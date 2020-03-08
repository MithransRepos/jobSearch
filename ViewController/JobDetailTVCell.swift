//
//  JobDetailTVCell.swift
//  JobSearch
//
//  Created by MithranN on 11/12/19.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit

class JobDetailTVCellVM: JobDetailTVCellDataSource {
    var companyName: String? {
        return job?.hiringCompany?.name
    }
    
    var title: String? {
        return job?.name
    }
    
    var descriptionText: String? {
        return job?.snippet
    }
    
    var location: String? {
        return job?.location
    }
    
    private let job: Job?
    
    init(job: Job?) {
        self.job = job
    }
}

public protocol JobDetailTVCellDataSource: class {
    var title: String? { get }
    var descriptionText: String? { get }
    var location: String? { get }
    var companyName: String? { get }
}


class JobDetailTVCell: BaseTableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.link
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let comapanyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    
    
    private var dataSource: JobDetailTVCellDataSource? {
        didSet {
            setData()
        }
    }
    
    func setDataSource(_ dataSource: JobDetailTVCellVM) {
        self.dataSource = dataSource
    }
    
    private func setData() {
        self.titleLabel.text = dataSource?.title
        self.descriptionLabel.text = dataSource?.descriptionText
        self.comapanyLabel.text = dataSource?.companyName
        self.locationLabel.text = dataSource?.location
    }
    
    override func addViews() {
        super.addViews()
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(comapanyLabel)
        contentView.addSubview(locationLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        titleLabel.set(.sameLeadingTrailing(contentView, Padding.p12), .top(contentView, Padding.p12))
        comapanyLabel.set(.leading(contentView, Padding.p12), .below(titleLabel, Padding.p12))
        locationLabel.set(.after(comapanyLabel, Padding.p12), .below(titleLabel, Padding.p12), .trailing(contentView,Padding.p12, .greaterThanOrEqual))
        descriptionLabel.set(.sameLeadingTrailing(contentView, Padding.p12), .below(comapanyLabel, Padding.p12), .bottom(contentView,Padding.p12))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        locationLabel.text = nil
        comapanyLabel.text = nil
    }
    
}

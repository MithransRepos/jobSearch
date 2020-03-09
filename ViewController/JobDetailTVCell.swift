//
//  JobDetailTVCell.swift
//  JobSearch
//
//  Created by MithranN on 11/12/19.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit
import DTCoreText

class JobDetailTVCellVM: JobDetailTVCellDataSource {

    var postedTime: String? {
        return job?.postedTimeFriendly
    }
    
    var companyName: String? {
        return job?.hiringCompany?.name
    }
    
    var title: String? {
        return job?.name
    }
    
    var htmlSnippet: NSAttributedString? {
        return job?.snippet?.returnAttributedStringForHTMLString(fontFamily: "Helvetica Neue",
                                                                 fontName: "HelveticaNeue",
                                                                 fontSize: 14,
                                                                 textColor: .black,
                                                                 textAlignment: .left)
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
    var htmlSnippet: NSAttributedString? { get }
    var location: String? { get }
    var companyName: String? { get }
    var postedTime: String? { get }
}


class JobDetailTVCell: BaseTableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.link
        label.numberOfLines = 0
        return label
    }()
    
    private let postedTime: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    private let snippetLabel: DTAttributedLabel = DTAttributedLabel()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    private let comapanyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = .black
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
        titleLabel.text = dataSource?.title
        postedTime.text = dataSource?.postedTime
        snippetLabel.attributedString = dataSource?.htmlSnippet
        comapanyLabel.text = dataSource?.companyName
        locationLabel.text = dataSource?.location
    }
    
    override func addViews() {
        super.addViews()
        contentView.addSubview(titleLabel)
        contentView.addSubview(postedTime)
        contentView.addSubview(snippetLabel)
        contentView.addSubview(comapanyLabel)
        contentView.addSubview(locationLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        titleLabel.set(.sameLeadingTrailing(contentView, Padding.p12), .top(contentView, Padding.p12))
        postedTime.set(.sameLeadingTrailing(contentView, Padding.p12), .below(titleLabel, Padding.p12))
        comapanyLabel.set(.leading(contentView, Padding.p12), .below(postedTime, Padding.p12))
        locationLabel.set(.after(comapanyLabel, Padding.p12), .below(postedTime, Padding.p12),
                          .trailing(contentView,Padding.p12, .greaterThanOrEqual))
        snippetLabel.set(.sameLeadingTrailing(contentView, Padding.p12),
                         .below(comapanyLabel, Padding.p12), .bottom(contentView,Padding.p12), .height(60))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        postedTime.text = nil
        snippetLabel.attributedString = nil
        locationLabel.text = nil
        comapanyLabel.text = nil
    }
    
}

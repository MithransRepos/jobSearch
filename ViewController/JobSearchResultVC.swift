//
//  JobSearchResultVC.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit


// MARK: DataSource protocol for JobSearchVC Datasource
public protocol JobSearchResultVCDataSource: class {
    var numberOfJobs: Int { get }
    func getJob(at index: Int) -> Job?
    func loadMoreIfNeeded(index: Int)
    var searchText: String? { get }
    var locationText: String? { get }
    var jobResultsTitle: String? { get }
    func performSearch()
    func getSearchRequestParam() -> ApiRequestParam
}

class JobSearchResultVC: BaseViewController {
    
    private var dataSource: JobSearchResultVCDataSource!
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Find the best jobs here!", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        dataSource = JobSearchVM(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Job Search"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search,
                                                            target: self, action: #selector(openJobSearchVC))
        searchButton.addTarget(self, action: #selector(openJobSearchVC), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        openJobSearchVC()
    }
      
    override func addViews() {
        super.addViews()
        view.addSubview(tableView)
        view.addSubview(searchButton)
    }
      
    override func setConstraints() {
        super.setConstraints()
        tableView.set(.fillSuperView(view))
        searchButton.set(.centerView(view), .width(200, .greaterThanOrEqual))
    }
      
    override func setupTableView()  {
        super.setupTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(JobDetailTVCell.self, forCellReuseIdentifier: JobDetailTVCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    @objc private func openJobSearchVC() {
        let jobSearchVC = JobSearchVC(searchRequestParam: dataSource.getSearchRequestParam())
        jobSearchVC.delegate = self
        self.present(jobSearchVC, animated: true, completion: nil)
    }
    
    override func apiCallCompleted() {
        super.apiCallCompleted()
        title = dataSource.jobResultsTitle
        searchButton.isHidden = dataSource.numberOfJobs != 0
        searchButton.setTitle("No jobs found! Try different input", for: .normal)
    }
}

// MARK: tableview delegate & dataSource functions
extension JobSearchResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfJobs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: JobDetailTVCell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell.reuseIdentifier,
                                                                      for: indexPath) as? JobDetailTVCell else {
                                                                        return UITableViewCell()
        }
        let cellDataSource = JobDetailTVCellVM(job: dataSource.getJob(at: indexPath.row))
        cell.accessoryType = .disclosureIndicator
        cell.setDataSource(cellDataSource)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let urlString = dataSource.getJob(at: indexPath.row)?.url, let url = URL(string: urlString) else {
          return //be safe
        }
        self.navigationController?.pushViewController(WebViewVC(urlRequest: URLRequest(url: url)), animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !tableView.isDecelerating || apiCallInProgess { return }
        dataSource.loadMoreIfNeeded(index: indexPath.row)
    }
    
}

// MARK: JobSearchVMDelegate functions
extension JobSearchResultVC: JobSearchVMDelegate {
    
    func didFetchJobs() {
        tableView.reloadData()
    }
    
    func didFailFetchUsers(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle:  .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension JobSearchResultVC: JobSearchVCDelegate {
    
    func didTapSearchButton(_ vc: UIViewController) {
        searchButton.isHidden = true
        vc.dismiss(animated: true, completion: nil)
        dataSource.performSearch()
    }
}

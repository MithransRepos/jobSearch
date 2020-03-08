//
//  JobSearchViewController.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit

// MARK: DataSource protocol for JobSearchVC Datasource
public protocol JobSearchVCDataSource: class {
    var numberOfJobs: Int { get }
    func getJob(at index: Int) -> Job?
}

class JobSearchViewController: BaseViewController {
    
     private var dataSource: JobSearchVCDataSource!
    
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

    }
      
    override func addViews() {
          super.addViews()
          view.addSubview(tableView)
      }
      
      override func setConstraints() {
          super.setConstraints()
          tableView.set(.fillSuperView(self.view))
      }
      
      override func setupTableView()  {
          super.setupTableView()
          tableView.dataSource = self
          tableView.delegate = self
          tableView.register(JobDetailTVCell.self, forCellReuseIdentifier: JobDetailTVCell.reuseIdentifier)
          tableView.tableFooterView = UIView()
      }

}

// MARK: tableview delegate & dataSource functions
extension JobSearchViewController: UITableViewDelegate, UITableViewDataSource {
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
    }
    
}

// MARK: JobSearchVMDelegate functions
extension JobSearchViewController: JobSearchVMDelegate {
    
    func didFetchJobs() {
        tableView.reloadData()
    }
    
    func didFailFetchUsers(errorMessage: String) {
        tableView.reloadData()
    }
}

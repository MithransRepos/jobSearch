//
//  JobSearchViewModel.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import Foundation
public protocol JobSearchVMDelegate: class {
    func didFetchJobs()
    func didFailFetchUsers(errorMessage: String)
    func apiCallInProgress()
    func apiCallCompleted()
    func showLoaderForLoadMore()
}
class JobSearchVM: NSObject {
    
    private let jobSearchDataManager: JobSearchDataManager = JobSearchDataManager()
    private var jobs: [Job] = []
    private weak var delegate: JobSearchVMDelegate?
    private let params = ApiRequestParam()
    private var totalJobs: Int = 0
    
    
    
    init(delegate: JobSearchVMDelegate) {
        self.delegate = delegate
        super.init()
        setupParams()
        searchJob()
    }
    
    private func setupParams() {
        params.searchText = "iOS developer"
        params.location = "Los vegas"
    }
    
    
    // Search job using API
    private func searchJob() {
        if params.currentPage > 1 {
            delegate?.showLoaderForLoadMore()
        }else {
            delegate?.apiCallInProgress()
        }
        let dictionary = try? params.asDictionary()
        JobSearchDataManager().searchJob(params: dictionary) { [weak self] result in
            switch result {
            case .success(let response):
                guard let jobs = response?.jobs, let self = self else {
                    return
                }
                self.totalJobs = response?.totalJobs ?? 0
                if self.params.currentPage > 1 {
                    self.jobs.append(contentsOf: jobs)
                }else {
                    self.jobs = jobs
                }
                self.delegate?.didFetchJobs()
            case .failure(let error):
                self?.delegate?.didFailFetchUsers(errorMessage: error.localizedDescription)
            }
            self?.delegate?.apiCallCompleted()
        }
    }
}

extension JobSearchVM: JobSearchVCDataSource {
    
    func loadMoreIfNeeded(index: Int) {
        if totalJobs == numberOfJobs { return }
        if index < numberOfJobs - 2 { return }
        params.currentPage += 1
        searchJob()
    }
    
    var numberOfJobs: Int {
       return jobs.count
    }
    
    func getJob(at index: Int) -> Job? {
        return jobs[safeIndex: index]
    }
    
    
}

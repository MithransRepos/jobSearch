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
}
class JobSearchVM: NSObject {
    
    private let jobSearchDataManager: JobSearchDataManager = JobSearchDataManager()
    private var jobs: [Job] = []
    private weak var delegate: JobSearchVMDelegate?
    private let params = ApiRequestParam()
    
    
    
    init(delegate: JobSearchVMDelegate) {
        self.delegate = delegate
        super.init()
        searchJob()
    }
    
    // Search job using API
    private func searchJob() {
        delegate?.apiCallInProgress()
        let dictionary = try? params.asDictionary()
        JobSearchDataManager().searchJob(params: dictionary) { [weak self] result in
            switch result {
            case .success(let response):
                guard let jobs = response?.jobs, let self = self else {
                    return
                }
                self.jobs = jobs
                self.delegate?.didFetchJobs()
            case .failure(let error):
                self?.delegate?.didFailFetchUsers(errorMessage: error.localizedDescription)
            }
            self?.delegate?.apiCallCompleted()
        }
    }
}

extension JobSearchVM: JobSearchVCDataSource {
    var numberOfJobs: Int {
       return jobs.count
    }
    
    func getJob(at index: Int) -> Job? {
        return jobs[safeIndex: index]
    }
    
    
}

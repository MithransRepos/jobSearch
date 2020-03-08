//
//  JobSearchDataManager.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import Foundation
class JobSearchDataManager {
    private let router = Router<JobSearchApi>()

    func searchJob(params: [String: Any]?, completion: @escaping (Result<ZipRecruiterResponse?, APIError>) -> Void) {
        router.fetch(.getJobs(params: params), decode: { json -> ZipRecruiterResponse? in
            json as? ZipRecruiterResponse
        }, completion: completion)
    }

}

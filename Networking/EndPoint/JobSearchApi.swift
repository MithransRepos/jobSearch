//
//  JobSearchApi.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import Foundation
public enum JobSearchApi {
    case getJobs(params: [String: Any]?)
}

extension JobSearchApi: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: NetworkConstants.BaseURL) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }

    var path: String {
        switch self {
        case .getJobs:
            return "/jobs/v1"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getJobs:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .getJobs(let params):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: params)
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}

//
//  ApiRequestParam.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import Foundation
public class ApiRequestParam: Codable {
    private let apiKey: String = NetworkConstants.ApiKey
    public var searchText: String?
    public var location: String?
    public var radiusMiles: Int?
    public var currentPage: Int = 1
    public var jobsPerPage: Int = 10
    public var daysAgo: Int?
    public var refineBySalary: Int?
    
    private enum CodingKeys : String, CodingKey {
        case apiKey = "api_key"
        case searchText = "search"
        case location
        case radiusMiles = "radius_miles"
        case currentPage = "page"
        case jobsPerPage = "jobs_per_page"
        case daysAgo = "days_ago"
        case refineBySalary = "refine_by_salary"
    }
}

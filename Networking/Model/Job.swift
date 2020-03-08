// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let job = try? newJSONDecoder().decode(Job.self, from: jsonData)

import Foundation

// MARK: - Job
struct Job: Codable {
    let country: Country?
    let hasNonZrURL: String?
    let url: String?
    let hasZipapply: Bool?
    let state: State?
    let buyerType: BuyerType?
    let id, source, city, postedTime: String?
    let industryName: IndustryName?
    let jobAge, salaryMax: Int?
    let salarySource: SalarySource?
    let postedTimeFriendly, category: String?
    let salaryInterval: SalaryInterval?
    let salaryMinAnnual: Int?
    let name, snippet, location: String?
    let salaryMin: Int?
    let hiringCompany: HiringCompany?
    let salaryMaxAnnual: Int?

    enum CodingKeys: String, CodingKey {
        case country
        case hasNonZrURL = "has_non_zr_url"
        case url
        case hasZipapply = "has_zipapply"
        case state
        case buyerType = "buyer_type"
        case id, source, city
        case postedTime = "posted_time"
        case industryName = "industry_name"
        case jobAge = "job_age"
        case salaryMax = "salary_max"
        case salarySource = "salary_source"
        case postedTimeFriendly = "posted_time_friendly"
        case category
        case salaryInterval = "salary_interval"
        case salaryMinAnnual = "salary_min_annual"
        case name, snippet, location
        case salaryMin = "salary_min"
        case hiringCompany = "hiring_company"
        case salaryMaxAnnual = "salary_max_annual"
    }
}

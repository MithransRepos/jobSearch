// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let job = try? newJSONDecoder().decode(Job.self, from: jsonData)

import Foundation

// MARK: - Job
public struct Job: Codable {
    let country: String?
    let url: String?
    let state: String?
    let id, source, city, postedTime: String?
    let industryName: String?
    let postedTimeFriendly, category: String?
    let name, snippet, location: String?
    let hiringCompany: HiringCompany?

    enum CodingKeys: String, CodingKey {
        case country
        case url
        case state
        case id, source, city
        case postedTime = "posted_time"
        case industryName = "industry_name"
        case postedTimeFriendly = "posted_time_friendly"
        case category
        case name, snippet, location
        case hiringCompany = "hiring_company"
    }
}

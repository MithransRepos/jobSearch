// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let job = try? newJSONDecoder().decode(Job.self, from: jsonData)

import Foundation

// MARK: - Job
public struct Job: Decodable {
    var country: String?
    var url: String?
    var state: String?
    var id, source, city, postedTime: String?
    var industryName: String?
    var postedTimeFriendly, category: String?
    var name, location: String?
    var hiringCompany: HiringCompany?
    let snippet: String?
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

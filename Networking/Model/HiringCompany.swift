// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let hiringCompany = try? newJSONDecoder().decode(HiringCompany.self, from: jsonData)

import Foundation

// MARK: - HiringCompany
struct HiringCompany: Codable {
    let hiringCompanyDescription: String?
    let name: String?
    let url, id: String?

    enum CodingKeys: String, CodingKey {
        case hiringCompanyDescription = "description"
        case name, url, id
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zipRecruiterResponse = try? newJSONDecoder().decode(ZipRecruiterResponse.self, from: jsonData)

import Foundation

// MARK: - ZipRecruiterResponse
struct ZipRecruiterResponse: Codable {
    let success: Bool?
    let jobs: [Job]?
    let numPaginableJobs, totalJobs: Int?

    enum CodingKeys: String, CodingKey {
        case success, jobs
        case numPaginableJobs = "num_paginable_jobs"
        case totalJobs = "total_jobs"
    }
}

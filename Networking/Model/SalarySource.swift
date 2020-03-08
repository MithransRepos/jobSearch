import Foundation

enum SalarySource: String, Codable {
    case parsed = "parsed"
    case predicted = "predicted"
    case provided = "provided"
}

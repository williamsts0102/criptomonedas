
import Foundation

struct ConversionResponse: Codable {
    let base: String
    let rates: [String: Double]
}

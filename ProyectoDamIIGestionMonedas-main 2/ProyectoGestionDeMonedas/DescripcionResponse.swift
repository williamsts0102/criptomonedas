
import Foundation


struct SimboloList: Codable {
    let symbols: [String: Simbolo]
}

struct Simbolo: Codable {
    let description: String
    let code: String
}




import Foundation

// MARK: - ZenQuotes API response model (GET https://zenquotes.io/api/random)
struct Quote: Codable {
    let q: String   // quote body
    let a: String   // author name
}

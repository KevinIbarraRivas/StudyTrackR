import UIKit

// MARK: - Subject enum (satisfies enum requirement)
enum Subject: String, Codable, CaseIterable {
    case mathematics    = "Math"
    case science        = "Science"
    case computerScience = "CS"
    case history        = "History"
    case english        = "English"
    case biology        = "Biology"
    case language       = "Language"
    case other          = "Other"

    var icon: String {
        switch self {
        case .mathematics:     return "📐"
        case .science:         return "🔬"
        case .computerScience: return "💻"
        case .history:         return "📜"
        case .english:         return "📖"
        case .biology:         return "🧬"
        case .language:        return "🌍"
        case .other:           return "📚"
        }
    }

    var color: UIColor {
        switch self {
        case .mathematics:     return UIColor(red: 0.18, green: 0.42, blue: 0.31, alpha: 1) // study green
        case .science:         return .systemTeal
        case .computerScience: return .systemPurple
        case .history:         return .systemOrange
        case .english:         return .systemRed
        case .biology:         return .systemMint
        case .language:        return .systemIndigo
        case .other:           return .systemGray
        }
    }

    // Short label for the bar chart x-axis
    var chartLabel: String { rawValue }
}

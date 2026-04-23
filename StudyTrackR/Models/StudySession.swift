import Foundation

// MARK: - Core data model stored in UserDefaults
struct StudySession: Codable {
    let id: UUID
    let subject: Subject
    let duration: Int   // seconds
    let notes: String
    let date: Date

    // Designated initialiser for new sessions
    init(subject: Subject, duration: Int, notes: String) {
        self.id       = UUID()
        self.subject  = subject
        self.duration = duration
        self.notes    = notes
        self.date     = Date()
    }

    // MARK: Computed helpers
    var formattedDuration: String {
        let h = duration / 3600
        let m = (duration % 3600) / 60
        let s = duration % 60
        if h > 0 { return String(format: "%dh %02dm", h, m) }
        if m > 0 { return String(format: "%dm %02ds", m, s) }
        return String(format: "%ds", s)
    }

    var shortDuration: String {
        let h = duration / 3600
        let m = (duration % 3600) / 60
        if h > 0 { return "\(h)h \(m)m" }
        return "\(m) min"
    }
}

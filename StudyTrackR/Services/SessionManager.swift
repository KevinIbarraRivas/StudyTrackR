import Foundation

// MARK: - Persistence layer (UserDefaults)
class SessionManager {

    static let shared = SessionManager()
    private init() {}

    private let sessionsKey = "studyTrackR_sessions"
    private let goalKey     = "studyTrackR_weeklyGoal"

    // MARK: - CRUD

    func getAllSessions() -> [StudySession] {
        guard
            let data     = UserDefaults.standard.data(forKey: sessionsKey),
            let sessions = try? JSONDecoder().decode([StudySession].self, from: data)
        else { return [] }
        return sessions.sorted { $0.date > $1.date }   // newest first
    }

    func addSession(_ session: StudySession) {
        var all = getAllSessions()
        all.append(session)
        save(all)
    }

    func deleteSession(id: UUID) {
        let updated = getAllSessions().filter { $0.id != id }
        save(updated)
    }

    // MARK: - Stats

    /// Total seconds studied today
    func todayTotal() -> Int {
        let cal   = Calendar.current
        let today = cal.startOfDay(for: Date())
        return getAllSessions()
            .filter { cal.startOfDay(for: $0.date) == today }
            .reduce(0) { $0 + $1.duration }
    }

    /// Consecutive-day streak (including today if studied)
    func currentStreak() -> Int {
        let cal    = Calendar.current
        let dates  = Set(getAllSessions().map { cal.startOfDay(for: $0.date) })
        var streak = 0
        var check  = cal.startOfDay(for: Date())
        while dates.contains(check) {
            streak += 1
            check   = cal.date(byAdding: .day, value: -1, to: check)!
        }
        return streak
    }

    /// Seconds per subject for the current ISO week
    func weeklyBySubject() -> [(subject: Subject, seconds: Int)] {
        let cal  = Calendar.current
        let now  = Date()
        let week = cal.dateInterval(of: .weekOfYear, for: now)!

        var totals: [Subject: Int] = [:]
        getAllSessions()
            .filter { week.contains($0.date) }
            .forEach { totals[$0.subject, default: 0] += $0.duration }

        return totals
            .map { (subject: $0.key, seconds: $0.value) }
            .sorted { $0.seconds > $1.seconds }
    }

    /// Total seconds this week
    func weeklyTotal() -> Int {
        weeklyBySubject().reduce(0) { $0 + $1.seconds }
    }

    // MARK: - Weekly goal (hours, stored as Int)
    var weeklyGoalHours: Int {
        get { UserDefaults.standard.integer(forKey: goalKey) == 0
              ? 15
              : UserDefaults.standard.integer(forKey: goalKey) }
        set { UserDefaults.standard.set(newValue, forKey: goalKey) }
    }

    // MARK: - Private
    private func save(_ sessions: [StudySession]) {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: sessionsKey)
        }
    }
}

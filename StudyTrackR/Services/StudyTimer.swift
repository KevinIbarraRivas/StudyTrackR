import Foundation

// MARK: - Timer engine that drives the Log Session screen
// Uses start-time anchoring so pausing and resuming is accurate
class StudyTimer {

    weak var delegate: TimerDelegate?

    private var timer: Timer?
    private var startDate: Date?
    private(set) var pausedElapsed: Int = 0
    private(set) var state: TimerState  = .idle

    // MARK: - Current elapsed (read-only)
    var elapsed: Int {
        guard let start = startDate else { return pausedElapsed }
        return pausedElapsed + Int(Date().timeIntervalSince(start))
    }

    // MARK: - Controls
    func start() {
        guard state != .running else { return }
        startDate = Date()
        state     = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.timerDidUpdate(elapsed: self.elapsed)
        }
    }

    func pause() {
        guard state == .running, let start = startDate else { return }
        pausedElapsed += Int(Date().timeIntervalSince(start))
        startDate = nil
        state     = .paused
        timer?.invalidate()
        timer = nil
    }

    func resume() {
        guard state == .paused else { return }
        start()
    }

    /// Stop the timer and return the final elapsed seconds, then reset
    func stop() -> Int {
        let final = elapsed
        reset()
        return final
    }

    func reset() {
        timer?.invalidate()
        timer         = nil
        startDate     = nil
        pausedElapsed = 0
        state         = .idle
    }

    // MARK: - Formatting helper (used in LogSessionViewController label)
    static func formatted(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        if h > 0 { return String(format: "%d:%02d:%02d", h, m, s) }
        return String(format: "%02d:%02d", m, s)
    }
}

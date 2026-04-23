import Foundation

// MARK: - Custom protocol (satisfies "beyond TableView protocols" requirement)
// Implemented by LogSessionViewController to receive live timer ticks
protocol TimerDelegate: AnyObject {
    func timerDidUpdate(elapsed: Int)
}

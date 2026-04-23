import UIKit

// MARK: - Tab 4: Stats – bar chart + weekly summary + streak
class StatsViewController: UIViewController {

    // MARK: - Subviews
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let content: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let weekHeaderLabel: UILabel = {
        let l = UILabel()
        l.text      = "This Week"
        l.font      = .systemFont(ofSize: 22, weight: .bold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let weekTotalLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 17, weight: .semibold)
        l.textColor = .studyGreen
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let streakCard: UIView = {
        let v = UIView()
        v.backgroundColor    = .studyGreen
        v.layer.cornerRadius = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let streakValueLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 36, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let streakTitleLabel: UILabel = {
        let l = UILabel()
        l.text      = "🔥 Day Streak"
        l.font      = .systemFont(ofSize: 14)
        l.textColor = UIColor.white.withAlphaComponent(0.85)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // Bar chart
    private let chartTitleLabel: UILabel = {
        let l = UILabel()
        l.text  = "Time by Subject"
        l.font  = .systemFont(ofSize: 16, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let barChartView: BarChartView = {
        let v = BarChartView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // Goal progress
    private let goalTitleLabel: UILabel = {
        let l = UILabel()
        l.text  = "Weekly Goal"
        l.font  = .systemFont(ofSize: 16, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let progressBar: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.trackTintColor    = .systemGray5
        pv.progressTintColor = .studyGreen
        pv.layer.cornerRadius = 4
        pv.clipsToBounds      = true
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()

    private let goalStatusLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let editGoalButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit Goal", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.setTitleColor(.studyGreen, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title                = "Stats"
        view.backgroundColor = .systemBackground
        setupLayout()
        editGoalButton.addTarget(self, action: #selector(editGoalTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshStats()
    }

    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(content)

        [weekHeaderLabel, weekTotalLabel, streakCard,
         chartTitleLabel, barChartView,
         goalTitleLabel, progressBar, goalStatusLabel, editGoalButton]
            .forEach { content.addSubview($0) }

        [streakValueLabel, streakTitleLabel].forEach { streakCard.addSubview($0) }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            content.topAnchor.constraint(equalTo: scrollView.topAnchor),
            content.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            weekHeaderLabel.topAnchor.constraint(equalTo: content.topAnchor, constant: 20),
            weekHeaderLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),

            weekTotalLabel.topAnchor.constraint(equalTo: weekHeaderLabel.bottomAnchor, constant: 4),
            weekTotalLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),

            // Streak card
            streakCard.topAnchor.constraint(equalTo: weekTotalLabel.bottomAnchor, constant: 20),
            streakCard.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            streakCard.widthAnchor.constraint(equalToConstant: 130),
            streakCard.heightAnchor.constraint(equalToConstant: 90),

            streakValueLabel.topAnchor.constraint(equalTo: streakCard.topAnchor, constant: 12),
            streakValueLabel.centerXAnchor.constraint(equalTo: streakCard.centerXAnchor),

            streakTitleLabel.topAnchor.constraint(equalTo: streakValueLabel.bottomAnchor, constant: 4),
            streakTitleLabel.centerXAnchor.constraint(equalTo: streakCard.centerXAnchor),
            streakTitleLabel.bottomAnchor.constraint(equalTo: streakCard.bottomAnchor, constant: -12),

            // Chart
            chartTitleLabel.topAnchor.constraint(equalTo: streakCard.bottomAnchor, constant: 28),
            chartTitleLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),

            barChartView.topAnchor.constraint(equalTo: chartTitleLabel.bottomAnchor, constant: 12),
            barChartView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            barChartView.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20),
            barChartView.heightAnchor.constraint(equalToConstant: 200),

            // Goal
            goalTitleLabel.topAnchor.constraint(equalTo: barChartView.bottomAnchor, constant: 28),
            goalTitleLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),

            editGoalButton.centerYAnchor.constraint(equalTo: goalTitleLabel.centerYAnchor),
            editGoalButton.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20),

            progressBar.topAnchor.constraint(equalTo: goalTitleLabel.bottomAnchor, constant: 10),
            progressBar.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 12),

            goalStatusLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 6),
            goalStatusLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            goalStatusLabel.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -30)
        ])
    }

    // MARK: - Data
    private func refreshStats() {
        let mgr        = SessionManager.shared
        let weekData   = mgr.weeklyBySubject()
        let weekSecs   = mgr.weeklyTotal()
        let streak     = mgr.currentStreak()
        let goalSecs   = mgr.weeklyGoalHours * 3600

        // Weekly total
        let wh = weekSecs / 3600
        let wm = (weekSecs % 3600) / 60
        weekTotalLabel.text = "Total: \(wh)h \(wm)m"

        // Streak
        streakValueLabel.text = "\(streak)"

        // Bar chart
        barChartView.bars = weekData.map {
            BarChartView.Bar(label: $0.subject.chartLabel,
                             value: $0.seconds,
                             color: $0.subject.color)
        }

        // Goal progress
        let progress   = goalSecs > 0 ? Float(weekSecs) / Float(goalSecs) : 0
        progressBar.setProgress(min(progress, 1.0), animated: true)

        let doneH = weekSecs / 3600
        let doneM = (weekSecs % 3600) / 60
        goalStatusLabel.text = "\(doneH)h \(doneM)m / \(mgr.weeklyGoalHours) hrs"
    }

    // MARK: - Actions
    @objc private func editGoalTapped() {
        let alert = UIAlertController(title: "Weekly Goal",
                                      message: "Set your weekly study goal in hours",
                                      preferredStyle: .alert)
        alert.addTextField { tf in
            tf.keyboardType  = .numberPad
            tf.placeholder   = "e.g. 15"
            tf.text          = "\(SessionManager.shared.weeklyGoalHours)"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let text = alert.textFields?.first?.text,
               let hours = Int(text), hours > 0 {
                SessionManager.shared.weeklyGoalHours = hours
                self?.refreshStats()
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

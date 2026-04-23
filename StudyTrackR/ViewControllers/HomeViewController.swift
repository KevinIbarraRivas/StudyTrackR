import UIKit

// MARK: - Tab 1: Home – today's summary + motivational quote
class HomeViewController: UIViewController {

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

    // Header card
    private let headerCard: UIView = {
        let v = UIView()
        v.backgroundColor    = .studyGreen
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let greetingLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 14)
        l.textColor = UIColor.white.withAlphaComponent(0.85)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let todayTimeLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 42, weight: .bold)
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let todaySubLabel: UILabel = {
        let l = UILabel()
        l.text      = "Today's study time"
        l.font      = .systemFont(ofSize: 13)
        l.textColor = UIColor.white.withAlphaComponent(0.75)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let streakLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 15, weight: .semibold)
        l.textColor = UIColor.white.withAlphaComponent(0.9)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // Start Session button
    private let startButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("▶  Start Session", for: .normal)
        btn.titleLabel?.font  = .systemFont(ofSize: 17, weight: .semibold)
        btn.backgroundColor   = .studyGreen
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 14
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // Quote card
    private let quoteCard: UIView = {
        let v = UIView()
        v.backgroundColor    = .secondarySystemBackground
        v.layer.cornerRadius = 14
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let quoteTextLabel: UILabel = {
        let l = UILabel()
        l.font          = .italicSystemFont(ofSize: 15)
        l.textColor     = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let quoteAuthorLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .studyGreen
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // Recent sessions
    private let recentHeaderLabel: UILabel = {
        let l = UILabel()
        l.text  = "Recent Sessions"
        l.font  = .systemFont(ofSize: 18, weight: .bold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let recentTableView: UITableView = {
        let tv = UITableView()
        tv.isScrollEnabled   = false
        tv.rowHeight         = 60
        tv.layer.cornerRadius = 12
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private var recentSessions: [StudySession] = []
    private var tableHeightConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "StudyTrackR"
        view.backgroundColor = .systemBackground
        setupLayout()

        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        recentTableView.dataSource = self
        recentTableView.delegate   = self
        recentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecentCell")

        fetchQuote()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshStats()
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(content)

        [headerCard, startButton, quoteCard, recentHeaderLabel, recentTableView]
            .forEach { content.addSubview($0) }

        [greetingLabel, todayTimeLabel, todaySubLabel, streakLabel]
            .forEach { headerCard.addSubview($0) }

        [quoteTextLabel, quoteAuthorLabel]
            .forEach { quoteCard.addSubview($0) }

        tableHeightConstraint = recentTableView.heightAnchor.constraint(equalToConstant: 0)

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

            // Header card
            headerCard.topAnchor.constraint(equalTo: content.topAnchor, constant: 16),
            headerCard.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            headerCard.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            greetingLabel.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 16),
            greetingLabel.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),

            todayTimeLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 4),
            todayTimeLabel.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),

            todaySubLabel.topAnchor.constraint(equalTo: todayTimeLabel.bottomAnchor, constant: 2),
            todaySubLabel.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),

            streakLabel.topAnchor.constraint(equalTo: todaySubLabel.bottomAnchor, constant: 12),
            streakLabel.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),
            streakLabel.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -16),

            // Start button
            startButton.topAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: 16),
            startButton.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),
            startButton.heightAnchor.constraint(equalToConstant: 54),

            // Quote card
            quoteCard.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            quoteCard.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            quoteCard.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            quoteTextLabel.topAnchor.constraint(equalTo: quoteCard.topAnchor, constant: 14),
            quoteTextLabel.leadingAnchor.constraint(equalTo: quoteCard.leadingAnchor, constant: 14),
            quoteTextLabel.trailingAnchor.constraint(equalTo: quoteCard.trailingAnchor, constant: -14),

            quoteAuthorLabel.topAnchor.constraint(equalTo: quoteTextLabel.bottomAnchor, constant: 8),
            quoteAuthorLabel.trailingAnchor.constraint(equalTo: quoteCard.trailingAnchor, constant: -14),
            quoteAuthorLabel.bottomAnchor.constraint(equalTo: quoteCard.bottomAnchor, constant: -14),

            // Recent header
            recentHeaderLabel.topAnchor.constraint(equalTo: quoteCard.bottomAnchor, constant: 24),
            recentHeaderLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),

            // Recent table
            recentTableView.topAnchor.constraint(equalTo: recentHeaderLabel.bottomAnchor, constant: 8),
            recentTableView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            recentTableView.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),
            recentTableView.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -24),
            tableHeightConstraint
        ])
    }

    // MARK: - Data

    private func refreshStats() {
        let mgr  = SessionManager.shared
        let secs = mgr.todayTotal()
        let h    = secs / 3600
        let m    = (secs % 3600) / 60

        todayTimeLabel.text = h > 0 ? "\(h)h \(m)m" : "\(m)m"
        streakLabel.text    = streakText(mgr.currentStreak())
        greetingLabel.text  = greeting()

        recentSessions = Array(mgr.getAllSessions().prefix(5))
        tableHeightConstraint.constant = CGFloat(recentSessions.count) * 60
        recentTableView.reloadData()
    }

    private func streakText(_ streak: Int) -> String {
        guard streak > 0 else { return "🔥 No streak yet – start today!" }
        return "🔥 \(streak)-day streak"
    }

    private func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning 👋"
        case 12..<17: return "Good afternoon 👋"
        default:     return "Good evening 👋"
        }
    }

    private func fetchQuote() {
        quoteTextLabel.text  = "Loading quote..."
        quoteAuthorLabel.text = ""

        // Closure usage – satisfies requirement
        QuoteService.shared.fetchQuote { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let q):
                    self?.quoteTextLabel.text  = "\u{201C}\(q.q)\u{201D}"
                    self?.quoteAuthorLabel.text = "\u{2014} \(q.a)"
                case .failure:
                    self?.quoteTextLabel.text  = "\u{201C}The secret of getting ahead is getting started.\u{201D}"
                    self?.quoteAuthorLabel.text = "\u{2014} Mark Twain"
                }
            }
        }
    }

    // MARK: - Actions

    @objc private func startTapped() {
        tabBarController?.selectedIndex = 1   // jump to Log tab
    }
}

// MARK: - UITableViewDataSource & Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recentSessions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell    = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath)
        let session = recentSessions[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text           = "\(session.subject.icon) \(session.subject.rawValue)"
        config.secondaryText  = session.shortDuration
        config.textProperties.font          = .systemFont(ofSize: 15, weight: .medium)
        config.secondaryTextProperties.font = .systemFont(ofSize: 14)
        config.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = config
        cell.selectionStyle       = .none
        return cell
    }
}

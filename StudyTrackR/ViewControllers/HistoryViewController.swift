import UIKit

// MARK: - Tab 3: History – grouped by date, swipe to delete
class HistoryViewController: UIViewController {

    // MARK: - Data model
    // Group sessions into Today / Yesterday / Earlier
    private struct Section {
        let title: String
        var sessions: [StudySession]
    }

    private var sections: [Section] = []

    // MARK: - Subviews
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.rowHeight          = UITableView.automaticDimension
        tv.estimatedRowHeight = 68
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text          = "No sessions yet.\nStart studying to see your history! 📖"
        l.textAlignment = .center
        l.numberOfLines = 2
        l.textColor     = .secondaryLabel
        l.font          = .systemFont(ofSize: 17)
        l.isHidden      = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title                = "History"
        view.backgroundColor = .systemGroupedBackground

        view.addSubview(tableView)
        view.addSubview(emptyLabel)

        tableView.dataSource = self
        tableView.delegate   = self
        tableView.register(SessionCell.self, forCellReuseIdentifier: SessionCell.reuseID)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buildSections()
        tableView.reloadData()
    }

    // MARK: - Data
    private func buildSections() {
        let cal   = Calendar.current
        let today = cal.startOfDay(for: Date())
        let yesterday = cal.date(byAdding: .day, value: -1, to: today)!

        var todaySessions:     [StudySession] = []
        var yesterdaySessions: [StudySession] = []
        var earlierSessions:   [StudySession] = []

        for session in SessionManager.shared.getAllSessions() {
            let day = cal.startOfDay(for: session.date)
            if day == today           { todaySessions.append(session) }
            else if day == yesterday  { yesterdaySessions.append(session) }
            else                      { earlierSessions.append(session) }
        }

        sections = []
        if !todaySessions.isEmpty     { sections.append(Section(title: "Today",     sessions: todaySessions)) }
        if !yesterdaySessions.isEmpty { sections.append(Section(title: "Yesterday", sessions: yesterdaySessions)) }
        if !earlierSessions.isEmpty   { sections.append(Section(title: "Earlier",   sessions: earlierSessions)) }

        emptyLabel.isHidden = !sections.isEmpty
    }
}

// MARK: - UITableViewDataSource & Delegate
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].sessions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Typecasting: as? SessionCell
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SessionCell.reuseID, for: indexPath) as? SessionCell
        else { return UITableViewCell() }

        cell.configure(with: sections[indexPath.section].sessions[indexPath.row])
        return cell
    }

    // Swipe-to-delete
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let session = sections[indexPath.section].sessions[indexPath.row]
        SessionManager.shared.deleteSession(id: session.id)
        sections[indexPath.section].sessions.remove(at: indexPath.row)

        if sections[indexPath.section].sessions.isEmpty {
            sections.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        emptyLabel.isHidden = !sections.isEmpty
    }
}

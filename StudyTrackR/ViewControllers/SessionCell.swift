import UIKit

// MARK: - Custom cell (satisfies custom UITableViewCell requirement)
class SessionCell: UITableViewCell {

    static let reuseID = "SessionCell"

    // Colored left bar by subject
    private let colorBar: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let subjectLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let notesLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let durationLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 14, weight: .semibold)
        l.textColor = .studyGreen
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    private func setupLayout() {
        [colorBar, subjectLabel, notesLabel, durationLabel].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            colorBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorBar.widthAnchor.constraint(equalToConstant: 4),
            colorBar.heightAnchor.constraint(equalToConstant: 36),

            subjectLabel.leadingAnchor.constraint(equalTo: colorBar.trailingAnchor, constant: 12),
            subjectLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            notesLabel.leadingAnchor.constraint(equalTo: subjectLabel.leadingAnchor),
            notesLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 2),
            notesLabel.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -8),
            notesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            durationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    // MARK: Configure (typecasting used in HistoryViewController: as? SessionCell)
    func configure(with session: StudySession) {
        subjectLabel.text  = "\(session.subject.icon) \(session.subject.rawValue)"
        notesLabel.text    = session.notes.isEmpty ? " " : session.notes
        durationLabel.text = session.shortDuration
        colorBar.backgroundColor = session.subject.color
    }
}

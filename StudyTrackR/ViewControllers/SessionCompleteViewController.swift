import UIKit

// MARK: - Data-passing screen shown after Stop & Save
// Receives a StudySession from LogSessionViewController
class SessionCompleteViewController: UIViewController {

    // MARK: - Passed data + callbacks
    var session: StudySession!
    var onSave:    ((StudySession) -> Void)?
    var onDiscard: (() -> Void)?

    // MARK: - Subviews

    private let checkImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        iv.tintColor  = .studyGreen
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let completedLabel: UILabel = {
        let l = UILabel()
        l.text      = "Session Complete!"
        l.font      = .systemFont(ofSize: 26, weight: .bold)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor    = .secondarySystemBackground
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let subjectRowLabel  = SessionCompleteViewController.makeRowLabel()
    private let durationRowLabel = SessionCompleteViewController.makeRowLabel()
    private let dateRowLabel     = SessionCompleteViewController.makeRowLabel()
    private let notesRowLabel: UILabel = {
        let l = UILabel()
        l.font          = .systemFont(ofSize: 15)
        l.numberOfLines = 0
        l.textColor     = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save Session", for: .normal)
        btn.titleLabel?.font    = .systemFont(ofSize: 17, weight: .semibold)
        btn.backgroundColor     = .studyGreen
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius  = 14
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let discardButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Discard", for: .normal)
        btn.titleLabel?.font    = .systemFont(ofSize: 17, weight: .semibold)
        btn.setTitleColor(.studyRed, for: .normal)
        btn.layer.borderColor   = UIColor.studyRed.cgColor
        btn.layer.borderWidth   = 1.5
        btn.layer.cornerRadius  = 14
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init (data passing requirement)
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title                = "Session Complete"
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        setupLayout()
        populateData()
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        discardButton.addTarget(self, action: #selector(discardTapped), for: .touchUpInside)
    }

    // MARK: - Layout
    private func setupLayout() {
        [checkImageView, completedLabel, cardView, saveButton, discardButton]
            .forEach { view.addSubview($0) }

        let divider1 = makeDivider()
        let divider2 = makeDivider()
        [subjectRowLabel, divider1, durationRowLabel, divider2, dateRowLabel, notesRowLabel]
            .forEach { cardView.addSubview($0) }

        NSLayoutConstraint.activate([
            checkImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            checkImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: 72),
            checkImageView.heightAnchor.constraint(equalToConstant: 72),

            completedLabel.topAnchor.constraint(equalTo: checkImageView.bottomAnchor, constant: 12),
            completedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            cardView.topAnchor.constraint(equalTo: completedLabel.bottomAnchor, constant: 28),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            subjectRowLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            subjectRowLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            subjectRowLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            divider1.topAnchor.constraint(equalTo: subjectRowLabel.bottomAnchor, constant: 12),
            divider1.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            divider1.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            divider1.heightAnchor.constraint(equalToConstant: 0.5),

            durationRowLabel.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 12),
            durationRowLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            durationRowLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            divider2.topAnchor.constraint(equalTo: durationRowLabel.bottomAnchor, constant: 12),
            divider2.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            divider2.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            divider2.heightAnchor.constraint(equalToConstant: 0.5),

            dateRowLabel.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 12),
            dateRowLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            dateRowLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            notesRowLabel.topAnchor.constraint(equalTo: dateRowLabel.bottomAnchor, constant: 12),
            notesRowLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            notesRowLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            notesRowLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),

            saveButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 54),

            discardButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            discardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            discardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            discardButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }

    // MARK: - Populate
    private func populateData() {
        subjectRowLabel.text  = "\(session.subject.icon)  Subject: \(session.subject.rawValue)"
        durationRowLabel.text = "⏱  Duration: \(session.formattedDuration)"

        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .short
        dateRowLabel.text = "📅  \(fmt.string(from: session.date))"

        if session.notes.isEmpty {
            notesRowLabel.isHidden = true
        } else {
            notesRowLabel.text = "📝  \(session.notes)"
        }
    }

    // MARK: - Actions
    @objc private func saveTapped() {
        onSave?(session)
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func discardTapped() {
        let alert = UIAlertController(title: "Discard Session?",
                                      message: "This session will not be saved.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
            self?.onDiscard?()
            self?.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Keep", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Helpers
    private static func makeRowLabel() -> UILabel {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }

    private func makeDivider() -> UIView {
        let v = UIView()
        v.backgroundColor = .separator
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
}

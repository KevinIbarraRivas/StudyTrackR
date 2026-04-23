import UIKit

// MARK: - Tab 2: Log – subject picker + live timer + notes + stop/save
class LogSessionViewController: UIViewController {

    // MARK: - State
    private let studyTimer   = StudyTimer()
    private var selectedSubject: Subject = .mathematics

    // MARK: - Subviews

    private let subjectLabel: UILabel = {
        let l = UILabel()
        l.text  = "Subject"
        l.font  = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let subjectButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font           = .systemFont(ofSize: 17, weight: .medium)
        btn.setTitleColor(.label, for: .normal)
        btn.backgroundColor    = .secondarySystemBackground
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // Circular timer display
    private let timerCircleView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 100
        v.layer.borderWidth  = 6
        v.layer.borderColor  = UIColor.studyGreen.cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let timerLabel: UILabel = {
        let l = UILabel()
        l.text      = "00:00"
        l.font      = .monospacedDigitSystemFont(ofSize: 46, weight: .semibold)
        l.textColor = .label
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let timerStateLabel: UILabel = {
        let l = UILabel()
        l.text      = "ready"
        l.font      = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let startPauseButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Start", for: .normal)
        btn.titleLabel?.font    = .systemFont(ofSize: 17, weight: .semibold)
        btn.backgroundColor     = .studyGreen
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius  = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let stopSaveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Stop & Save", for: .normal)
        btn.titleLabel?.font    = .systemFont(ofSize: 17, weight: .semibold)
        btn.backgroundColor     = .studyRed
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius  = 12
        btn.isEnabled           = false
        btn.alpha               = 0.5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let notesHeaderLabel: UILabel = {
        let l = UILabel()
        l.text      = "Notes (optional)"
        l.font      = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let notesTextView: UITextView = {
        let tv = UITextView()
        tv.font              = .systemFont(ofSize: 15)
        tv.backgroundColor   = .secondarySystemBackground
        tv.layer.cornerRadius = 10
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let placeholderLabel: UILabel = {
        let l = UILabel()
        l.text      = "e.g. Chapter 4, derivatives..."
        l.font      = .systemFont(ofSize: 15)
        l.textColor = .tertiaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title                = "Log Session"
        view.backgroundColor = .systemBackground
        studyTimer.delegate  = self

        setupLayout()
        updateSubjectButton()

        subjectButton.addTarget(self, action: #selector(subjectTapped), for: .touchUpInside)
        startPauseButton.addTarget(self, action: #selector(startPauseTapped), for: .touchUpInside)
        stopSaveButton.addTarget(self, action: #selector(stopSaveTapped), for: .touchUpInside)

        notesTextView.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Layout

    private func setupLayout() {
        [subjectLabel, subjectButton, timerCircleView,
         startPauseButton, stopSaveButton, notesHeaderLabel, notesTextView]
            .forEach { view.addSubview($0) }

        timerCircleView.addSubview(timerLabel)
        timerCircleView.addSubview(timerStateLabel)
        notesTextView.addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            subjectLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            subjectLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            subjectButton.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 6),
            subjectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subjectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            subjectButton.heightAnchor.constraint(equalToConstant: 50),

            // Timer circle – centered, 200×200
            timerCircleView.topAnchor.constraint(equalTo: subjectButton.bottomAnchor, constant: 30),
            timerCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerCircleView.widthAnchor.constraint(equalToConstant: 200),
            timerCircleView.heightAnchor.constraint(equalToConstant: 200),

            timerLabel.centerXAnchor.constraint(equalTo: timerCircleView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerCircleView.centerYAnchor, constant: -10),

            timerStateLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 4),
            timerStateLabel.centerXAnchor.constraint(equalTo: timerCircleView.centerXAnchor),

            // Start / Pause
            startPauseButton.topAnchor.constraint(equalTo: timerCircleView.bottomAnchor, constant: 24),
            startPauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startPauseButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            startPauseButton.heightAnchor.constraint(equalToConstant: 50),

            // Stop & Save
            stopSaveButton.topAnchor.constraint(equalTo: timerCircleView.bottomAnchor, constant: 24),
            stopSaveButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            stopSaveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stopSaveButton.heightAnchor.constraint(equalToConstant: 50),

            // Notes
            notesHeaderLabel.topAnchor.constraint(equalTo: startPauseButton.bottomAnchor, constant: 24),
            notesHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            notesTextView.topAnchor.constraint(equalTo: notesHeaderLabel.bottomAnchor, constant: 6),
            notesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notesTextView.heightAnchor.constraint(equalToConstant: 100),

            placeholderLabel.topAnchor.constraint(equalTo: notesTextView.topAnchor, constant: 10),
            placeholderLabel.leadingAnchor.constraint(equalTo: notesTextView.leadingAnchor, constant: 14)
        ])
    }

    // MARK: - UI helpers

    private func updateSubjectButton() {
        let title = "\(selectedSubject.icon)  \(selectedSubject.rawValue)    ›"
        subjectButton.setTitle(title, for: .normal)
        subjectButton.setTitleColor(selectedSubject.color, for: .normal)
        timerCircleView.layer.borderColor = selectedSubject.color.cgColor
    }

    private func setStopSaveEnabled(_ on: Bool) {
        stopSaveButton.isEnabled = on
        stopSaveButton.alpha     = on ? 1.0 : 0.5
    }

    // MARK: - Actions

    @objc private func subjectTapped() {
        guard studyTimer.state == .idle else { return }  // lock while timer runs
        let sheet = UIAlertController(title: "Select Subject", message: nil, preferredStyle: .actionSheet)
        for sub in Subject.allCases {
            sheet.addAction(UIAlertAction(title: "\(sub.icon)  \(sub.rawValue)", style: .default) { [weak self] _ in
                self?.selectedSubject = sub
                self?.updateSubjectButton()
            })
        }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }

    @objc private func startPauseTapped() {
        switch studyTimer.state {
        case .idle:
            studyTimer.start()
            startPauseButton.setTitle("Pause", for: .normal)
            timerStateLabel.text = "running"
            setStopSaveEnabled(true)
            subjectButton.isEnabled = false
        case .running:
            studyTimer.pause()
            startPauseButton.setTitle("Resume", for: .normal)
            timerStateLabel.text = "paused"
        case .paused:
            studyTimer.resume()
            startPauseButton.setTitle("Pause", for: .normal)
            timerStateLabel.text = "running"
        }
    }

    @objc private func stopSaveTapped() {
        let elapsed = studyTimer.stop()
        let notes   = notesTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let session = StudySession(subject: selectedSubject, duration: elapsed, notes: notes)
        let destVC  = SessionCompleteViewController()
        destVC.session   = session
        destVC.onSave    = { [weak self] saved in
            SessionManager.shared.addSession(saved)
            self?.resetUI()
        }
        destVC.onDiscard = { [weak self] in
            self?.resetUI()
        }
        navigationController?.pushViewController(destVC, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func resetUI() {
        timerLabel.text          = "00:00"
        timerStateLabel.text     = "ready"
        startPauseButton.setTitle("Start", for: .normal)
        setStopSaveEnabled(false)
        notesTextView.text       = ""
        placeholderLabel.isHidden = false
        subjectButton.isEnabled  = true
    }
}

// MARK: - TimerDelegate (custom protocol conformance)
extension LogSessionViewController: TimerDelegate {
    func timerDidUpdate(elapsed: Int) {
        timerLabel.text = StudyTimer.formatted(elapsed)
    }
}

// MARK: - UITextViewDelegate
extension LogSessionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

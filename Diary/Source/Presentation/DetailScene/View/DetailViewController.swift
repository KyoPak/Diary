//
//  DetailViewController.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import UIKit
import CoreLocation

final class DetailViewController: UIViewController {
    weak var coordinator: DetailCoordinator?
    
    private let viewModel: DetailViewModel
    private let navigationView = NavigationView()
    
    private var textStackViewBottomConstraints: NSLayoutConstraint?
    private var locationManager: CLLocationManager?
    
    private lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.text = viewModel.checkTextViewPlaceHolder()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.saveData(contents: contentsTextView.text)
        viewModel.deleteDataAfterCheck()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishLeft()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentsTextView.delegate = self
        setupCoreLocationAuthority()
        setupNotification()
        setupNavigationBar()
        bind()
        setupUI()
        setupConstraints()
    }
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.bindData { [weak self] data in
            self?.contentsTextView.text = data.contentText
            self?.textConfigure(text: data.contentText)
            self?.navigationView.setuplabel(text: Formatter.changeCustomDate(data.createdAt))
        }
        
        setupWeatherImage()
    }
    
    private func textConfigure(text: String) {
        var seperateText = text.components(separatedBy: "\n")
        let range = (seperateText.first! as NSString).range(of: seperateText.removeFirst())
        contentsTextView.attributedText = NSMutableAttributedString.customAttributeTitle(
            text: contentsTextView.text,
            range: range
        )
        contentsTextView.textColor = .label
    }
}

// MARK: - UITextView Delegate
extension DetailViewController: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentsTextView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == viewModel.checkTextViewPlaceHolder() {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = viewModel.checkTextViewPlaceHolder()
            textView.textColor = .systemGray
        }
        viewModel.saveData(contents: textView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let range = textView.selectedTextRange else { return }
        guard let position = textView.position(from: range.start, offset: 0) else { return }
        
        let seperateText = contentsTextView.text.components(separatedBy: "\n")
        guard let titleText = seperateText.first else { return }
        let ranges = (titleText as NSString).range(of: titleText)
        
        contentsTextView.attributedText = NSMutableAttributedString.customAttributeTitle(
            text: contentsTextView.text,
            range: ranges
        )
        
        textView.textColor = .label
        textView.selectedTextRange = textView.textRange(from: position, to: position)
    }
}

// MARK: - Action, Present
extension DetailViewController {
    @objc private func optionButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.viewModel.saveData(contents: self.contentsTextView.text)
            self.presentActivityView(data: self.viewModel.fetchDiaryReport())
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.deleteData()
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach(alert.addAction(_:))
        present(alert, animated: true)
    }
    
    private func presentLocationAlert() {
        let alert = UIAlertController(
            title: "위치 권한 요청",
            message: "위치 권한을 허용 하시겠습니까?",
            preferredStyle: .alert
        )
        let conformAction = UIAlertAction(title: "허용", style: .default) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingURL)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        [cancelAction, conformAction].forEach(alert.addAction(_:))

        self.present(alert, animated: true)
    }
}

// MARK: - CoreLocation
extension DetailViewController: CLLocationManagerDelegate {
    private func setupCoreLocationAuthority() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        switch locationManager?.authorizationStatus {
        case .denied:
            presentLocationAlert()
        case .notDetermined, .restricted:
            locationManager?.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            break
        }
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard viewModel.mode == .new else { return }
        
        if let coordinate = locations.last?.coordinate {
            viewModel.fetchWeatherData(
                lat: String(coordinate.latitude),
                long: String(coordinate.longitude)) { [weak self] in
                    self?.setupWeatherImage()
                }
        }
        locationManager?.stopUpdatingLocation()
    }
}

// MARK: - Keyboard Event
extension DetailViewController {
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func showKeyboard(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            setupConstraintForKeyboard(constant: -(keyboardHeight + 10))
        }
    }
    
    @objc private func hideKeyboard() {
        setupConstraintForKeyboard(constant: -10)
        viewModel.saveData(contents: contentsTextView.text)
    }
}

// MARK: - UI Configure
extension DetailViewController {
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray6
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(optionButtonTapped)
        )

        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.titleView = navigationView
    }
    
    private func setupWeatherImage() {
        viewModel.fetchImageData { [weak self] data in
            self?.navigationView.setupImage(image: UIImage(data: data))
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        contentsTextView.layer.borderWidth = 1
        contentsTextView.layer.cornerRadius = 10
        contentsTextView.layer.borderColor = UIColor.systemGray4.cgColor
        view.addSubview(contentsTextView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            contentsTextView.topAnchor.constraint(
                equalTo: safeArea.topAnchor, constant: 10),
            contentsTextView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor, constant: 10),
            contentsTextView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor, constant: -10)
        ])
        
        textStackViewBottomConstraints = contentsTextView.bottomAnchor.constraint(
            equalTo: safeArea.bottomAnchor, constant: -10)
        textStackViewBottomConstraints?.isActive = true
    }
    
    private func setupConstraintForKeyboard(constant: CGFloat) {
        textStackViewBottomConstraints?.isActive = false
        textStackViewBottomConstraints = contentsTextView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant)
        textStackViewBottomConstraints?.isActive = true
    }
}

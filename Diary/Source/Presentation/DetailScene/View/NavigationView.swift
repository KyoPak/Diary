//
//  NavigationView.swift
//  Diary
//
//  Created by Kyo on 2023/02/21.
//

import UIKit

final class NavigationView: UIStackView {
    private let navigationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var navigationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [navigationImageView, navigationLabel].forEach(addArrangedSubview(_:))
        spacing = 5
        axis = .horizontal
        alignment = .center
        distribution = .fill
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setuplabel(text: String) {
        navigationLabel.text = text
    }
    
    func setupImage(image: UIImage?) {
        navigationImageView.image = image
    }
}

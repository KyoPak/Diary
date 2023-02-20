//
//  DetailViewController.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import UIKit

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    
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

    private lazy var navigationStackView = UIStackView(
        subview: [navigationImageView, navigationLabel],
        spacing: 5,
        axis: .horizontal,
        alignment: .center,
        distribution: .fill
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension DetailViewController {
    
}

// MARK: - Action
extension DetailViewController {
    @objc private func optionButtonTapped() {
        
    }
}


// MARK: - CoreLocation
extension DetailViewController {
    
}

// MARK: - UI Configure
extension DetailViewController {
    private func setupNavigationBar() {
        navigationLabel.text = viewModel.convertDateText()
        
        viewModel.fetchImageData { [weak self] data in
            self?.navigationImageView.image = UIImage(data: data)
        }
        
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(optionButtonTapped)
        )

        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.titleView = navigationStackView
    }
}


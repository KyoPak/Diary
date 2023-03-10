//
//  ListCell.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import UIKit

final class ListCell: UICollectionViewListCell {
    private var viewModel: CellViewModel?
    
    private let titleLabel = UILabel(textStyle: .title3)
    private let dateLabel = UILabel(textStyle: .body)
    private let previewLabel = UILabel(textStyle: .caption1)
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imageStackview = UIStackView(
        subview: [iconImageView],
        spacing: 0,
        axis: .vertical,
        alignment: .fill,
        distribution: .fill
    )
    
    private lazy var bottomStackView = UIStackView(
        subview: [dateLabel, imageStackview, previewLabel],
        spacing: 5,
        axis: .horizontal,
        alignment: .firstBaseline,
        distribution: .fill
    )
    
    private lazy var labelStackView = UIStackView(
        subview: [titleLabel, bottomStackView],
        spacing: 5,
        axis: .vertical,
        alignment: .leading,
        distribution: .fillEqually
    )

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        [titleLabel, previewLabel, dateLabel].forEach { $0.text = nil }
    }
    
    func setupViewModel(_ viewModel: CellViewModel) {
        self.viewModel = viewModel
    }
    
    func bind() {
        viewModel?.bindData { [weak self] diaryReport in
            var content = diaryReport.contentText.components(separatedBy: "\n")
            
            self?.titleLabel.text = content.removeFirst()
            self?.previewLabel.text = content.joined(separator: " ")
            self?.dateLabel.text = Formatter.changeCustomDate(diaryReport.createdAt)
        }
        
        viewModel?.fetchImageData { [weak self] data in
            self?.iconImageView.image = UIImage(data: data)
        }
    }
}

// MARK: - UI Configure
extension ListCell {
    private func setupUI() {
        contentView.addSubview(labelStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor, constant: 5),
            labelStackView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor, constant: -5),
            labelStackView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor, constant: 20),
            labelStackView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor, constant: -20),
            
            imageStackview.widthAnchor.constraint(
                equalTo: imageStackview.heightAnchor),
            imageStackview.heightAnchor.constraint(
                lessThanOrEqualTo: dateLabel.heightAnchor)
        ])
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}

extension ListCell: ViewIdentifiable { }

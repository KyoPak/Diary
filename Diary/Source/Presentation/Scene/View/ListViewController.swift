//
//  ListViewController.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import UIKit

final class ListViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DiaryReport>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiaryReport>
    
    enum Section {
        case main
    }
    
    private lazy var dataSource = configureDataSource()
    
    private let viewModel: ListViewModel
    private let collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - DataSource, Snapshot
extension ListViewController {
    private func configureDataSource() {
        let dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, data in
            
            
        }
        return dataSource
    }
    
    private func applySnapshot(datas: [DiaryReport], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(datas)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - UIAction
extension ListViewController {
    @objc private func addButtonTapped() {
        
    }
}

// MARK: - UI Configure
extension ListViewController {
    private func setupNavigationBar() {
        title = "일기장"
        let appearence = UINavigationBarAppearance()
        appearence.backgroundColor = .systemGray5
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
        
        let addBarButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = addBarButton
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

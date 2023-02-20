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
    private lazy var collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupNavigationBar()
        setupUI()
        setupConstraint()
    }
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.bindData { [weak self] datas in
            self?.applySnapshot(datas: datas)
        }
    }
}

// MARK: - DataSource, Snapshot
extension ListViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, data in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifiable, for: indexPath) as? ListCell else {
                let errorCell = UICollectionViewCell()
                return errorCell
            }
            
            //TODO: Cell Configure
            return cell
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
    
    private func swipe(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: deleteActionTitle) { [weak self] _, _, _ in
            self?.viewModel.deleteData(index: indexPath?.item)
            
        }
        
        let shareActionTitle = NSLocalizedString("Share", comment: "Share action title")
        let shareAction = UIContextualAction(style: .normal,
                                             title: shareActionTitle) { [weak self] _, _, _ in
            
            self?.moveToActivityView(data: self?.viewModel.fetchSelectData(index: indexPath?.item))
        }
        deleteAction.backgroundColor = .systemPink
        shareAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
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
        configureCollectionView()
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = .some({ indexPath in
            self.swipe(for: indexPath)
        })
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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

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
    
    weak var coordinator: ListCoordinator?
    
    private lazy var dataSource = configureDataSource()
    
    private let viewModel: ListViewModel
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupNavigationBar()
        setupSearchBar()
        setupUI()
        registerCell()
        setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setup()
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
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCell.identifiable,
                for: indexPath
            ) as? ListCell else {
                
                let errorCell = UICollectionViewCell()
                return errorCell
            }
            
            let cellViewModel = CellViewModel(
                diary: data,
                weatherImageUseCase: DefaultLoadWeatherImageUseCase(
                    weatherAPIRepository: DefaultWeatherAPIRepository()
                ),
                cacheUseCase: self.viewModel.cacheUseCase
            )
            
            cell.setupViewModel(cellViewModel)
            cell.bind()
            
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

// MARK: - CollectionView Delegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.createDetailCoordinator(data: viewModel.fetchSelectData(index: indexPath.item))
    }
}

// MARK: - Present Error Alert
extension ListViewController: ErrorPresentable {
    func presentErrorAlert(title: String, message: String) {
        let alertDirector = AlertDirector(style: .alert)
        present(alertDirector.setupAlert(title: title, message: message), animated: true)
    }
}

// MARK: - UIAction
extension ListViewController {
    @objc private func addButtonTapped() {
        coordinator?.createDetailCoordinator(data: nil)
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
            
            self?.presentActivityView(data: self?.viewModel.fetchSelectData(index: indexPath?.item))
        }
        deleteAction.backgroundColor = .systemPink
        shareAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        viewModel.setupFilterText(text)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.clearFilterData()
    }
}

// MARK: - UI Configure
extension ListViewController {
    private func setupNavigationBar() {
        title = "Diary"
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

        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Content"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupUI() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = .some({ indexPath in
            self.swipe(for: indexPath)
        })
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func registerCell() {
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifiable)
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

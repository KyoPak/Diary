//
//  ListCoordinator.swift
//  Diary
//
//  Created by Kyo on 2023/02/23.
//

import UIKit

final class ListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var coreDataRepository: CoreDataRepository
    
    init(navigationController: UINavigationController,
         coreDataRepository: CoreDataRepository
    ) {
        self.navigationController = navigationController
        self.coreDataRepository = coreDataRepository
    }
    
    func start() {
        let viewModel = ListViewModel(
            fetchUseCase: DefaultFetchDiaryReportsUseCase(coreDataRepository: coreDataRepository),
            deleteUseCase: DefaultDeleteDiaryReportUseCase(coreDataRepository: coreDataRepository),
            cacheUseCase: DefaultCacheCheckUseCase(
                cacheRepository: DefaultCacheRepository(cacheService: DefaultCacheService())
            )
        )
        
        let viewController = ListViewController(viewModel: viewModel)
        viewController.coordinator = self
        viewModel.errorDelegate = viewController
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func createDetailCoordinator(data: DiaryReport?) {
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            coreDataRepository: coreDataRepository,
            data: data
        )
        detailCoordinator.parentCoordinator = self
        childCoordinators.append(detailCoordinator)
        
        detailCoordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

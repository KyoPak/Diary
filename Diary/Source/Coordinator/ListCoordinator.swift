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
    var diaryDataRepository: DiaryDataRepository
    var currentWeatherRepository: CurrentWeatherRepository
    
    init(navigationController: UINavigationController,
         diaryDataRepository: DiaryDataRepository,
         currentWeatherRepository: CurrentWeatherRepository
    ) {
        self.navigationController = navigationController
        self.diaryDataRepository = diaryDataRepository
        self.currentWeatherRepository = currentWeatherRepository
    }
    
    func start() {
        let viewModel = ListViewModel(
            fetchUseCase: DefaultFetchDiaryReportsUseCase(diaryDataRepository: diaryDataRepository),
            deleteUseCase: DefaultDeleteDiaryReportUseCase(diaryDataRepository: diaryDataRepository),
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
            diaryDataRepository: diaryDataRepository,
            currentWeatherRepository: currentWeatherRepository,
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

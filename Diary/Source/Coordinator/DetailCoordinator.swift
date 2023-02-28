//
//  DetailCoordinator.swift
//  Diary
//
//  Created by Kyo on 2023/02/23.
//

import UIKit

final class DetailCoordinator: Coordinator {
    var parentCoordinator: ListCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var coreDataRepository: CoreDataRepository
    var networkRepository: NetworkRepository
    
    private var data: DiaryReport?
    
    init(navigationController: UINavigationController,
         coreDataRepository: CoreDataRepository,
         networkRepository: NetworkRepository,
         data: DiaryReport?
    ) {
        self.navigationController = navigationController
        self.coreDataRepository = coreDataRepository
        self.networkRepository = networkRepository
        self.data = data
    }
    
    func start() {
        let viewModel = DetailViewModel(
            data: data,
            fetchWeatherDataUseCase: DefaultFetchWeatherDataUseCase(
                networkRepository: networkRepository
            ),
            weatherImageUseCase: DefaultLoadWeatherImageUseCase(
                networkRepository: networkRepository
            ),
            createDiaryUseCase: DefaultSaveDiaryReportUseCase(
                coreDataRepository: coreDataRepository
            ),
            delteUseCase: DefaultDeleteDiaryReportUseCase(
                coreDataRepository: coreDataRepository
            )
        )
        
        let viewController = DetailViewController(viewModel: viewModel)
        viewController.coordinator = self
        
        viewModel.errorDelegate = viewController
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishLeft() {
        parentCoordinator?.childDidFinish(self)
    }
}

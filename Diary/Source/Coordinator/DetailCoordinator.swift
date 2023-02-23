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
    
    private var data: DiaryReport?
    
    init(navigationController: UINavigationController,
         coreDataRepository: CoreDataRepository,
         data: DiaryReport?
    ) {
        self.navigationController = navigationController
        self.coreDataRepository = coreDataRepository
        self.data = data
    }
    
    func start() {
        let weatherAPIRepository = DefaultWeatherAPIRepository()
        
        let viewModel = DetailViewModel(
            data: data,
            fetchWeatherDataUseCase: DefaultFetchWeatherDataUseCase(
                weatherAPIRepository: weatherAPIRepository
            ),
            weatherImageUseCase: DefaultLoadWeatherImageUseCase(
                weatherAPIRepository: weatherAPIRepository
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
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishLeft() {
        parentCoordinator?.childDidFinish(self)
    }
}

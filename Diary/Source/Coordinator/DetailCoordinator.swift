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
    var diaryDataRepository: DiaryDataRepository
    var currentWeatherRepository: CurrentWeatherRepository
    
    private var data: DiaryReport?
    
    init(navigationController: UINavigationController,
         diaryDataRepository: DiaryDataRepository,
         currentWeatherRepository: CurrentWeatherRepository,
         data: DiaryReport?
    ) {
        self.navigationController = navigationController
        self.diaryDataRepository = diaryDataRepository
        self.currentWeatherRepository = currentWeatherRepository
        self.data = data
    }
    
    func start() {
        let viewModel = DetailViewModel(
            data: data,
            fetchWeatherDataUseCase: DefaultFetchWeatherDataUseCase(
                currentWeatherRepository: currentWeatherRepository
            ),
            weatherImageUseCase: DefaultLoadWeatherImageUseCase(
                currentWeatherRepository: currentWeatherRepository
            ),
            createDiaryUseCase: DefaultSaveDiaryReportUseCase(
                diaryDataRepository: diaryDataRepository
            ),
            delteUseCase: DefaultDeleteDiaryReportUseCase(
                diaryDataRepository: diaryDataRepository
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

//
//  MainCoordinator.swift
//  Diary
//
//  Created by Kyo on 2023/02/23.
//

import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
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
        let listCoordinator = ListCoordinator(
            navigationController: navigationController,
            diaryDataRepository: diaryDataRepository,
            currentWeatherRepository: currentWeatherRepository
        )
        
        listCoordinator.parentCoordinator = self
        childCoordinators.append(listCoordinator)
        
        listCoordinator.start()
    }
}

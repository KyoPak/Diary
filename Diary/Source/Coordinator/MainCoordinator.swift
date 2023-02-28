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
    var coreDataRepository: CoreDataRepository
    var networkRepository: NetworkRepository
    
    init(navigationController: UINavigationController,
         coreDataRepository: CoreDataRepository,
         networkRepository: NetworkRepository
    ) {
        self.navigationController = navigationController
        self.coreDataRepository = coreDataRepository
        self.networkRepository = networkRepository
    }
    
    func start() {
        let listCoordinator = ListCoordinator(
            navigationController: navigationController,
            coreDataRepository: coreDataRepository,
            networkRepository: networkRepository
        )
        
        listCoordinator.parentCoordinator = self
        childCoordinators.append(listCoordinator)
        
        listCoordinator.start()
    }
}

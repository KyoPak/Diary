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
    
    init(navigationController: UINavigationController,
         coreDataRepository: CoreDataRepository
    ) {
        self.navigationController = navigationController
        self.coreDataRepository = coreDataRepository
    }
    
    func start() {
        let listCoordinator = ListCoordinator(
            navigationController: navigationController,
            coreDataRepository: coreDataRepository
        )
        
        listCoordinator.parentCoordinator = self
        childCoordinators.append(listCoordinator)
        
        listCoordinator.start()
    }
}

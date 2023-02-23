//
//  Coordinator.swift
//  Diary
//
//  Created by Kyo on 2023/02/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var coreDataRepository: CoreDataRepository { get set }
    func start()
}

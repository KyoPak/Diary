//
//  Diary - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        let diaryDataRepository = DefaultDiaryDataRepository(
            coreDataService: DefaultCoreDataService()
        )

        let currentWeatherRepository = DefaultCurrentWeatherRepository(
            networkService: DefaultNetworkSevice()
        )
        
        let coordinator = MainCoordinator(
            navigationController: navigationController,
            diaryDataRepository: diaryDataRepository,
            currentWeatherRepository: currentWeatherRepository
        )
        
        coordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

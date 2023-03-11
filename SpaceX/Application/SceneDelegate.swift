//
//  SceneDelegate.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 06.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark
        
        let networkService = RocketNetworkService()
        let rocketsPageViewModel = RocketsPageViewModel(networkService: networkService)
        let rocketsPageVC = RocketsPageViewController(viewModel: rocketsPageViewModel)
        let navController = UINavigationController(rootViewController: rocketsPageVC)
        navController.navigationBar.tintColor = .label
        window?.rootViewController = navController
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 17.11.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = SplashViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

}


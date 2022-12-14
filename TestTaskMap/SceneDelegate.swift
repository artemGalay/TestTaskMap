//
//  SceneDelegate.swift
//  TestTaskMap
//
//  Created by Артем Галай on 29.09.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewcontroller = ViewController()
        window?.rootViewController = viewcontroller
        window?.makeKeyAndVisible()
    }
}


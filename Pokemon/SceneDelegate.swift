//
//  SceneDelegate.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var router: HomeRouter?
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let navigation = UINavigationController()
            navigation.navigationBar.barTintColor = UIColor(red: 22/255, green: 27/255, blue: 34/255, alpha: 1)
            navigation.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigation.navigationBar.barStyle = .black
            window.rootViewController = navigation
            self.window = window
            window.makeKeyAndVisible()
            router = HomeRouter(navigation, title: "Pokemon List")
            router?.start()
        }
    }
}

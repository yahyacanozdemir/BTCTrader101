//
//  SceneDelegate.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate {
  
  var window: UIWindow?
  var discoverCoordinator: DiscoverCoordinator?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    UIApplication.shared.delegate = self
    
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = BaseNavigationController()
    
    discoverCoordinator = DiscoverCoordinator(
      navigationController: window?.rootViewController as! BaseNavigationController)
    discoverCoordinator?.start()
    
    window?.makeKeyAndVisible()
  }
  
}

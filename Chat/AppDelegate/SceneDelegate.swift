//
//  SceneDelegate.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: - Properties
  
  var window: UIWindow?
  var coordinator: MainCoordinator?
  
  // MARK: - Lifecycle
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    
    guard let scene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: scene)
    
    coordinator = MainCoordinator(window: window!)
    coordinator!.start()
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    UIApplication.shared.applicationIconBadgeNumber = 0
    NotificationCenter.default.post(name: .shouldReloadChats, object: nil)
  }
  
}

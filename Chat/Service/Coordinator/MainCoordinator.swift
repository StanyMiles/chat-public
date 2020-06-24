//
//  MainCoordinator.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

struct MainCoordinator {
  
  // MARK: - Properties
  
  let window: UIWindow
  
  // MARK: - init
  
  init(window: UIWindow) {
    self.window = window
  }
  
  // MARK: - Funcs
  
  func start() {
    
    do {
      let _ = try TokenKeychain().retrieve()
      presentSplitController()
    } catch {
      presentLoginController()
    }
    
    window.makeKeyAndVisible()
  }
  
  func signOut() {
    
    do {
      let _ = try TokenKeychain().remove()
    } catch {
      print("Failed to delete token from keychain:", error.localizedDescription)
    }
    
    presentLoginController()
  }
  
  func presentLoginController() {
    
    let rootController = window.rootViewController
    let vc = LoginController.instantiate()
    
    window.rootViewController = vc
    rootController?.dismiss(animated: true)
  }
  
  func presentSplitController() {
    
    let rootController = window.rootViewController
    let vc = SplitViewController.instantiate()
    
    window.rootViewController = vc
    rootController?.dismiss(animated: true)
  }
  
  func present(_ chat: Chat, didReceiveLastMessage: ((Message) -> Void)?) {
    
    guard let splitController = window.rootViewController as? SplitViewController else { return }
    
    let vc = ChatController.instantiate()
    vc.chat = chat
    vc.didReceiveLastMessage = didReceiveLastMessage
    
    splitController.showDetailViewController(vc, sender: nil)
  }
  
}

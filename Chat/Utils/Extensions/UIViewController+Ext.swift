//
//  UIViewController+Ext.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 30.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

extension UIViewController {
  
  var coordinator: MainCoordinator {
    
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let sceneDelegate = windowScene.delegate as? SceneDelegate else {
        fatalError("Failed to access SceneDelegate")
    }
    
    guard let coordinator = sceneDelegate.coordinator else {
      fatalError("Coordinator must exist")
    }
    
    return coordinator
  }
  
  func presentAlert(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style = .alert,
    actions: [UIAlertAction] = [.ok]
  ) {
    
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: preferredStyle)
    
    actions.forEach { alert.addAction($0) }
    
    present(alert, animated: true)
  }
  
  func hideKeyboard() {
    view.endEditing(true)
  }
}

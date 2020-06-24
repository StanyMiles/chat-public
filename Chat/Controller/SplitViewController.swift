//
//  SplitViewController.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    delegate = self
  }
}

// MARK: - Storyboarded
extension SplitViewController: Storyboarded {}

// MARK: - UISplitViewControllerDelegate
extension SplitViewController: UISplitViewControllerDelegate {
  
  func splitViewController(
    _ splitViewController: UISplitViewController,
    collapseSecondary secondaryViewController: UIViewController,
    onto primaryViewController: UIViewController
  ) -> Bool {
    
    guard UIDevice.isPhone else { return false }
    
    guard let navController = secondaryViewController as? UINavigationController,
      let chatController = navController.topViewController as? ChatController else {
        return true
    }
    
    return chatController.chat == nil
  }
}

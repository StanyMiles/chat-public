//
//  Storyboarded.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

protocol Storyboarded {
  static func instantiate(_ storyboard: Storyboard) -> Self
}

extension Storyboarded where Self: UIViewController {
  
  static func instantiate(_ storyboard: Storyboard = .main) -> Self {
    
    let fullName = NSStringFromClass(self)
    let className = fullName.components(separatedBy: ".")[1]
    let storyboard = UIStoryboard(
      name: storyboard.rawValue,
      bundle: Bundle.main)
    
    return storyboard.instantiateViewController(
      withIdentifier: className) as! Self
  }
}

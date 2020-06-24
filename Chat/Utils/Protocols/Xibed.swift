//
//  Xibed.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 06.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

protocol Xibed {
  static func instantiate() -> Self
}

extension Xibed where Self: UIView {
  
  static func instantiate() -> Self {
    
    let fullName = NSStringFromClass(self)
    let className = fullName.components(separatedBy: ".")[1]
    
    return UINib(nibName: className, bundle: nil)
      .instantiate(withOwner: nil, options: nil)[0] as! Self
  }
}

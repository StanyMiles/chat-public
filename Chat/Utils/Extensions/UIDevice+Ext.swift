//
//  UIDevice+Ext.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

extension UIDevice {
  
  static var isPhone: Bool = {
    current.userInterfaceIdiom == .phone
  }()
  
  static var isPad: Bool = {
    current.userInterfaceIdiom == .pad
  }()
}

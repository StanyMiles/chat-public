//
//  String+Ext.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 20.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

extension String {
  
  var firstLetter: String {
    String(first ?? " ")
  }
}

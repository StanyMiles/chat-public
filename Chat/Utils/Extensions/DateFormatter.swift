//
//  DateFormatter.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 07.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

extension DateFormatter {
  
  static let message: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    return formatter
  }()
}

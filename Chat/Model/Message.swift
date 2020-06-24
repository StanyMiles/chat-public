//
//  Message.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct Message {
  
  // MARK: - Properties
  
  let id: UUID
  let senderId: UUID
  let date: Date
  let text: String
  
  // MARK: - Funcs
  
  func isSent(by user: User) -> Bool {
    user.id == senderId
  }
}

// MARK: - Decodable
extension Message: Decodable {}

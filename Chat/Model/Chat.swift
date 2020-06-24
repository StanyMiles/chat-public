//
//  Chat.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct Chat {
  let id: UUID
  let users: [User]
  var lastMessage: Message?
}

// MARK: - Decodable
extension Chat: Decodable {}

// MARK: - Equatable
extension Chat: Equatable {
  static func == (lhs: Chat, rhs: Chat) -> Bool {
    lhs.id == rhs.id
  }
}

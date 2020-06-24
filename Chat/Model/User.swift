//
//  User.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct User {
  let id: UUID
  var username: String
  let email: String
  var avatarUrlString: String?
  
  var avatarURL: URL? {
    guard let avatarUrlString = avatarUrlString else { return nil }
    return URL(string: avatarUrlString)
  }
}

// MARK: - Codable
extension User: Codable {}

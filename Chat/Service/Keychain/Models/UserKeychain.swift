//
//  UserKeychain.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 14.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct UserKeychain: Keychain {
  
  var account = "com.example.chat.user"
  var service = "userToken"
  
  typealias DataType = User
}

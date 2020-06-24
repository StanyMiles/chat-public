//
//  TokenKeychain.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 30.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct TokenKeychain: Keychain {
  
  var account = "com.example.chat.token"
  var service = "userToken"
  
  typealias DataType = Token
}

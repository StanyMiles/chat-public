//
//  APNTokenKeychain.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 18.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct APNTokenKeychain: Keychain {
  
  var account = "com.example.chat.apntoken"
  var service = "userToken"
  
  typealias DataType = String
}

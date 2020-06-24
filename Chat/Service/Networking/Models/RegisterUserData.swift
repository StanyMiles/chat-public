//
//  RegisterUserData.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 31.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct RegisterUserData: Encodable {
  let username: String
  let email: String
  let password: String
  let confirmPassword: String
}

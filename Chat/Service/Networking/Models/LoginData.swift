//
//  LoginData.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 30.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct LoginData: Decodable {
  let token: String
  let user: User
}

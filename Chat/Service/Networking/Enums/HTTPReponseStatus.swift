//
//  HTTPReponseStatus.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 30.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

enum HTTPReponseStatus {
  case success
  case clientError
  case serverError
  case timeout
  case unknownResponse
}

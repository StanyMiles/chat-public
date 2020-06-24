//
//  HTTPHeader.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 30.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

enum HTTPHeader {
  case contentType(value: ContentType)
  case authorization(type: AuthorizationType, hash: String)
  case contentLength(Int)
}

extension HTTPHeader {
  
  typealias Parameters = (field: String, value: String)
  
  var parameters: Parameters {
    
    switch self {
      case .contentType(let value):
        return ("Content-Type", value.value)
      
      case .authorization(let type, let hash):
        return ("Authorization", "\(type.rawValue) \(hash)")
      
      case .contentLength(let length):
        return ("Content-Length", String(length))
    }
  }
}

//
//  ContentType.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 30.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

enum ContentType {
  case applicationJson
  case multipartFormData(boundary: String)
  
  var value: String {
    
    switch self {
      
      case .applicationJson:
        return "application/json"
      
      case .multipartFormData(let boundary):
        return "multipart/form-data; boundary=" + boundary
    }
  }
}

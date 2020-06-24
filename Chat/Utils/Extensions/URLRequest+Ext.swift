//
//  URLRequest+Ext.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 30.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

extension URLRequest {
  
  mutating func addHeader(_ header: HTTPHeader) {
    
    let (field, value) = header.parameters
    addValue(value, forHTTPHeaderField: field)
  }
}

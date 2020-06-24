//
//  URLSession+Ext.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 30.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

extension URLSession {
  
  typealias Handler = (Data?, URLResponse?, Error?) -> Void
  
  @discardableResult
  func request(
    _ endpoint: Endpoint,
    then handler: @escaping Handler
  ) -> URLSessionDataTask {
    
    let task = dataTask(
      with: endpoint.request,
      completionHandler: handler)
    
    task.resume()
    
    return task
  }
}

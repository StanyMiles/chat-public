//
//  ImageLoader.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 20.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

struct ImageLoader {
  
  // MARK: - Properties
  
  static let shared = ImageLoader(networking: .shared)
  
  let networking: Networking
  
  // MARK: - Funcs
  
  func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    
    networking.downloadImage(from: url) { result in
      
      switch result {
        
        case .success(let data):
          
          let image = UIImage(data: data)
          
          DispatchQueue.main.async {
            completion(image)
          }
        
        case .failure:
          
          DispatchQueue.main.async {
            completion(nil)
          }
      }
    }
  }
}

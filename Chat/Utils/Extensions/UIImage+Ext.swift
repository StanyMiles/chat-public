//
//  UIImage+Ext.swift
//  B-Counter
//
//  Created by Stanislav Kobiletski on 30.04.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

extension UIImage {
  
  func resize(to largestSide: CGFloat = 128) -> UIImage {
    
    guard size.width > largestSide,
      size.height > largestSide else { return self }
    
    let scale: CGFloat
    
    if size.width > size.height {
      scale = largestSide / size.width
    } else {
      scale = largestSide / size.height
    }
    
    let newWidth  = size.width * scale
    let newHeight = size.height * scale
    let newSize   = CGSize(width: newWidth, height: newHeight)
    
    let renderer = UIGraphicsImageRenderer(size: newSize)
    
    return renderer.image { context in
      self.draw(in: CGRect(origin: .zero, size: newSize))
    }
  }
  
}

//
//  RoundedView.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 19.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
  
  // MARK: - Properties
  
  @IBInspectable
  var roundTopLeftCorner: Bool = false
  
  @IBInspectable
  var roundTopRightCorner: Bool = false
  
  @IBInspectable
  var roundBottomLeftCorner: Bool = false
  
  @IBInspectable
  var roundBottomRightCorner: Bool = false
  
  @IBInspectable
  var cornerRadius: CGFloat = 0
  
  // MARK: - Lifecycle
  
  override func prepareForInterfaceBuilder() {
    setupView()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupView()
  }
  
  // MARK: - Funcs
  
  private func setupView() {
    
    var corners: UIRectCorner = []
    
    if roundTopLeftCorner {
      corners.insert(.topLeft)
    }
    if roundTopRightCorner {
      corners.insert(.topRight)
    }
    if roundBottomLeftCorner {
      corners.insert(.bottomLeft)
    }
    if roundBottomRightCorner {
      corners.insert(.bottomRight)
    }
    
    round(corners: corners, radius: cornerRadius)
  }
  
}

private extension RoundedView {
  
  @discardableResult
  private func round(
    corners: UIRectCorner,
    radius: CGFloat
  ) -> CAShapeLayer {
    
    let path = UIBezierPath(
      roundedRect: bounds,
      byRoundingCorners: corners,
      cornerRadii: CGSize(
        width: radius,
        height: radius))
    
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
    
    return mask
  }
  
}

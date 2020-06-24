//
//  CustomButton.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 18.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
  
  // MARK: - Properties
  
  @IBInspectable
  var cornerRadius: CGFloat = 0
  
  @IBInspectable
  var shadowColor: UIColor? = nil
  
  @IBInspectable
  var shadowRadius: CGFloat = 0
  
  @IBInspectable
  var shadowOffset: CGSize = .zero
  
  @IBInspectable
  var shadowOpacity: Float = 0
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupButton()
  }
  
  override func prepareForInterfaceBuilder() {
    setupButton()
  }
  
  // MARK: - Funcs
  
  private func setupButton() {
    layer.cornerRadius = cornerRadius
    layer.shadowColor = shadowColor?.cgColor
    layer.shadowRadius = shadowRadius
    layer.shadowOffset = shadowOffset
    layer.shadowOpacity = shadowOpacity
  }
}

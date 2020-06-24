//
//  CustomImageView.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 19.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

@IBDesignable
class CustomImageView: UIImageView {
  
  // MARK: - Properties
  
  @IBInspectable
  var cornerRadius: CGFloat = 0
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  override func prepareForInterfaceBuilder() {
    setupView()
  }
  
  // MARK: - Funcs
  
  private func setupView() {
    layer.cornerRadius = cornerRadius
  }
}

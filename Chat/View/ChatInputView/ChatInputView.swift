//
//  ChatInputView.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 06.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class ChatInputView: UIView {
  
  // MARK: - Properties
  
  static let standardHeight: CGFloat = 48
  
  weak var delegate: ChatInputViewDelegate?
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var textField: UITextField!
  @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

  // MARK: - Lifecycle
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    
    if let window = self.window {
      
      self.bottomAnchor.constraint(
        lessThanOrEqualToSystemSpacingBelow:
        window.safeAreaLayoutGuide.bottomAnchor,
        multiplier: 1).isActive = true
    }
  }
  // MARK: - IBActions
  
  @IBAction private func handleSendMessage(_ sender: Any) {
    
    guard let text = textField.text else { return }
    guard !text.isEmpty else { return }
    
    textField.text = nil
    delegate?.didSend(text)
  }
 
}

// MARK: - Xibed
extension ChatInputView: Xibed {}

//
//  ChatTableCell.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 19.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class ChatTableCell: UITableViewCell {
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var avatarImageView: UIImageView!
  @IBOutlet private weak var usernameFirstCharacterLabel: UILabel!
  @IBOutlet private weak var usernameLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet private weak var unreadMessagesIndicator: UIView!
  
  // MARK: - Lifecycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    avatarImageView.image = nil
    usernameFirstCharacterLabel.text = nil
    messageLabel.text = nil
    dateLabel.text = nil
    unreadMessagesIndicator.isHidden = true
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    usernameFirstCharacterLabel.text = nil
    messageLabel.text = nil
    dateLabel.text = nil
    unreadMessagesIndicator.isHidden = true
  }
  
  // MARK: - Funcs
  
  func setup(
    with chat: Chat,
    hasUnreadMessages: Bool,
    imageLoader: ImageLoader = .shared,
    dateFormatter: DateFormatter = .message
  ) {
    
    guard let user = chat.users.first else { return }
    
    unreadMessagesIndicator.isHidden = !hasUnreadMessages
    
    let username = user.username
    
    usernameLabel.text = username
    
    if let avatarURL = user.avatarURL {
      
      imageLoader.downloadImage(from: avatarURL) { [weak self] image in
        
        guard let self = self else { return }
        
        guard let image = image else {
          self.usernameFirstCharacterLabel.text = username.firstLetter
          return
        }
        
        self.avatarImageView.image = image
      }
      
    } else {
      usernameFirstCharacterLabel.text = username.firstLetter
    }
    
    if let lastMessage = chat.lastMessage {
      dateLabel.text = dateFormatter.string(from: lastMessage.date)
      messageLabel.text = lastMessage.text
    }
  }
}

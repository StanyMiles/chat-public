//
//  UserTableCell.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 19.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class UserTableCell: UITableViewCell {
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var avatarImageView: UIImageView!
  @IBOutlet private weak var usernameFirstCharacterLabel: UILabel!
  @IBOutlet private weak var usernameLabel: UILabel!
  
  // MARK: - Lifecycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    avatarImageView.image = nil
    usernameFirstCharacterLabel.text = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    usernameFirstCharacterLabel.text = nil
  }
  
  // MARK: - Funcs
  
  func setup(with user: User, imageLoader: ImageLoader = .shared) {
    
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
  }
}

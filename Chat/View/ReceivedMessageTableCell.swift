//
//  ReceivedMessageTableCell.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 05.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class ReceivedMessageTableCell: UITableViewCell {
  
  // MARK: - Properties
  
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var messageLabel: UILabel!
  
  // MARK: - Funcs
  
  func setup(with message: Message, formatter: DateFormatter = .message) {
    dateLabel.text = formatter.string(from: message.date)
    messageLabel.text = message.text
  }
}
// TODO: add avatar + username

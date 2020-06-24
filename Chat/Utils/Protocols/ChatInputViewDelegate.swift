//
//  ChatInputViewDelegate.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 07.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

protocol ChatInputViewDelegate: class {
  func didSend(_ text: String)
}

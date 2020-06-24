//
//  NSNotification.Name+Ext.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 21.06.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

extension NSNotification.Name {
  static let shouldReloadChats = NSNotification.Name("com.example.should.reload.chats")
  static let didReceiveMessage = NSNotification.Name("com.example.did.receive.message")
}

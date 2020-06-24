//
//  ChatListController.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class ChatListController: UITableViewController {
  
  // MARK: - Properties
  
  private var chats: [Chat] = []
  private var chatsWithUnreadMessages: Set<String> = []
  
  var networking: Networking = .shared
  var notificationCenter: NotificationCenter = .default
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchChats()
    setupNotificationObervers()
  }
  
  // MARK: - IBActions
  
  @IBSegueAction private func searchUsersSeque(
    _ coder: NSCoder
  ) -> UINavigationController? {
    
    let navController = UINavigationController(coder: coder)
    
    if let searchController = navController?.topViewController as? SearchController {
      searchController.handleDidReceiveChat = handleDidReceiveChat
    }
    
    return navController
  }
  
  // MARK: - Funcs
  
  private func fetchChats() {
    
    networking.fetchChats { [weak self] result in
      
      guard let self = self else { return }
      
      switch result {
        
        case .success(let chats):
          self.chats = chats
        
        case .failure(let error):
          print("Failed to fetch chats", error.localizedDescription)
          self.chats.removeAll()
      }
      
      self.tableView.reloadData()
    }
  }
  
  private func handleDidReceiveChat(_ chat: Chat) {
    
    if let row = chats.firstIndex(of: chat) {
      
      let indexPath = IndexPath(row: row, section: 0)
      tableView.moveRow(at: indexPath, to: .zero)
      
    } else {
      
      chats.insert(chat, at: 0)
      tableView.insertRows(at: [.zero], with: .automatic)
    }
    
    tableView(tableView, didSelectRowAt: .zero)
  }

  private func set(_ lastMessage: Message, at indexPath: IndexPath) {
    chats[indexPath.row].lastMessage = lastMessage
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
  
  private func didReceiveMessage(for chatId: String) {
    
    chatsWithUnreadMessages.insert(chatId)

    for (row, chat) in chats.enumerated() {
      if chat.id.uuidString == chatId {
 
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        break
      }
    }
  }
  
  private func setupNotificationObervers() {
    
    notificationCenter.addObserver(
      forName: .shouldReloadChats,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      
      guard let self = self else { return }
      self.fetchChats()
    }
    
    notificationCenter.addObserver(
      forName: .didReceiveMessage,
      object: nil,
      queue: .main
    ) { [weak self] notification in
      
      guard let self = self else { return }
      
      guard let chatId = notification
        .userInfo?["chatId"] as? String else { return }
      
      self.didReceiveMessage(for: chatId)
    }
  }
}

// MARK: - UITableViewDataSource
extension ChatListController {
  
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    
    chats.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    
    let chat = chats[indexPath.row]
    let hasUnreadMessages = chatsWithUnreadMessages.contains(chat.id.uuidString)
    
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: CellID.cellId,
      for: indexPath) as? ChatTableCell else {
        fatalError("ChatTableCell is not set in storyboard")
    }
    
    cell.setup(with: chat, hasUnreadMessages: hasUnreadMessages)
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ChatListController {

  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    
    let chat = chats[indexPath.row]
    
    chatsWithUnreadMessages.remove(chat.id.uuidString)
    tableView.reloadRows(at: [indexPath], with: .automatic)
    
    coordinator.present(chat) { [weak self] lastMessage in
      guard let self = self else { return }
      self.set(lastMessage, at: indexPath)
    }
  }
}

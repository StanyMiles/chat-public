//
//  ChatController.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit
import Starscream

class ChatController: UITableViewController {
  
  // MARK: - Properties
  
  private lazy var websocket: WebSocket = {
    
    guard let chat = chat else {
      fatalError("Chat with user has not been provided to ChatController")
    }
    
    do {
      let websocket = try Networking
        .shared
        .makeWebSocket(for: chat, delegate: self)
      
      return websocket
      
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  
  private lazy var user: User = {
    do {
      return try UserKeychain().retrieve()
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  
  var networking: Networking = .shared
  
  var didReceiveLastMessage: ((Message) -> Void)?
  
  var chat: Chat?
  private var messages: [Message] = []
  
  private lazy var chatInputView: ChatInputView = {

    let width = view.frame.width
    let height = ChatInputView.standardHeight
    let size = CGSize(width: width, height: height)
    
    let view = ChatInputView.instantiate()
    view.frame = CGRect(origin: .zero, size: size)
    view.delegate = self
    return view
  }()
  
  override var inputAccessoryView: UIView? { chatInputView }
  override var canBecomeFirstResponder: Bool { true }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationTitle()
    fetchMessages()
    websocket.connect()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    websocket.disconnect()
  }
  
  // MARK: - Funcs
  
  private func setupNavigationTitle() {
    navigationItem.title = chat?.users.first?.username
  }
  
  private func fetchMessages() {
    
    guard let chat = chat else {
      fatalError("Chat has not been provided to ChatController")
    }
    
    networking.fetchMessages(for: chat) { [weak self] result in
      
      guard let self = self else { return }
      
      switch result {
        
        case .success(let messages):
          self.add(messages)
        
        case .failure(let error):
          print("Failed to fetch messages:", error.localizedDescription)
      }
    }
  }
  
  private func add(_ messages: [Message]) {
    
    guard !messages.isEmpty else { return }
    
    let start = self.messages.count
    self.messages.append(contentsOf: messages)
    let end = self.messages.count
    
    let indexPaths = (start..<end).map({ IndexPath(row: $0, section: 0) })
    guard let lastIndexPath = indexPaths.last else { return }
    
    tableView.insertRows(at: indexPaths, with: .automatic)
    tableView.scrollToRow(
      at: lastIndexPath,
      at: .bottom,
      animated: true)
    
    if messages.count == 1 {
      didReceiveLastMessage?(messages[0])
    }
  }
}

// MARK: - Storyboarded
extension ChatController: Storyboarded {}

// MARK: - ChatInputViewDelegate
extension ChatController: ChatInputViewDelegate {
  
  func didSend(_ text: String) {
    websocket.write(string: text)
  }
}

// MARK: - UITableViewDataSource
extension ChatController {
  
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    
    messages.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    
    let message = messages[indexPath.row]
    
    // TODO: Refactor out of here, maybe use some Protocol to unify cells
    if message.isSent(by: user) {
    
      guard let cell = tableView
        .dequeueReusableCell(
          withIdentifier: CellID.sentCellId,
          for: indexPath) as? SentMessageTableCell else {
            fatalError("SentMessageTableCell is not set up in Storyboard")
      }
      
      cell.setup(with: message)
      return cell
      
    } else {
      
      guard let cell = tableView
        .dequeueReusableCell(
          withIdentifier: CellID.receivedCellId,
          for: indexPath) as? ReceivedMessageTableCell else {
            fatalError("ReceivedMessageTableCell is not set up in Storyboard")
      }
      
      cell.setup(with: message)
      return cell
    }
  }
}

extension ChatController: Starscream.WebSocketDelegate {

  func didReceive(event: WebSocketEvent, client: WebSocket) {
    switch event {
      case .connected(let headers):
        print("connected \(headers)")
      
      case .disconnected(let reason, let closeCode):
        print("disconnected \(reason) \(closeCode)")
        dismiss(animated: true)
      
      case .text(let text):
        print("received text: \(text)")
      
      case .binary(let data):
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
          let message = try decoder.decode(Message.self, from: data)
          add([message])
          
        } catch {
          print("Failed to decode Messages:", error.localizedDescription)
        }
        
      case .pong(let pongData):
        print("received pong: \(String(describing: pongData))")
      case .ping(let pingData):
        print("received ping: \(String(describing: pingData))")
      case .error(let error):
        print("error \(String(describing: error))")
      case .viabilityChanged:
        print("viabilityChanged")
      case .reconnectSuggested:
        print("reconnectSuggested")
      case .cancelled:
        
        print("cancelled")
        dismiss(animated: true)
    }
  }
}

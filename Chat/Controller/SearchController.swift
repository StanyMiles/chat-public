//
//  SearchController.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit
import Combine

class SearchController: UITableViewController {
  
  // MARK: - Properties
  
  private var users: [User] = []
  
  var handleDidReceiveChat: ((Chat) -> Void)?
  var networking: Networking = .shared
  
  private var stored: Set<AnyCancellable> = []
  private let publisher = PassthroughSubject<String, Never>()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    subscribeToPublisher()
  }
  
  // MARK: - Funcs
  
  private func subscribeToPublisher() {
    
    publisher
      .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
      .sink(receiveValue: searchUsers)
      .store(in: &stored)
  }
  
  private func searchUsers(with username: String) {
    
    networking.searchUsers(with: username) { [weak self] result in
      
      guard let self = self else { return }
      
      switch result {
        
        case .success(let users):
          self.users = users
        
        case .failure(let error):
          print("Failed to attempt search", error.localizedDescription)
          self.users.removeAll()
      }
      
      self.tableView.reloadData()
    }
  }
  
  private func fetchChat(for user: User) {
    
    networking.fetchChat(with: user) { [weak self] result in


      guard let self = self else { return }

      switch result {

        case .success(let chat):

          self.dismiss(animated: true) {
            self.handleDidReceiveChat?(chat)
          }

        case .failure(let error):
          print("Failed to fetch chat with user \(user.username):",
            error.localizedDescription)
      }
    }
  }
  
}

// MARK: - UITableViewDataSource
extension SearchController {
  
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    
    users.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    
    let user = users[indexPath.row]
    
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: CellID.cellId,
      for: indexPath) as? UserTableCell else {
        fatalError("UserTableCell is not set in storyboard")
    }
    
    cell.setup(with: user)
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension SearchController {
  
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    
    let user = users[indexPath.row]
    fetchChat(for: user)
  }
}

// MARK: - UISearchBarDelegate
extension SearchController: UISearchBarDelegate {
  
  func searchBar(
    _ searchBar: UISearchBar,
    textDidChange searchText: String
  ) {
    
    guard !searchText.isEmpty else {
      users.removeAll()
      tableView.reloadData()
      return
    }
    
    publisher.send(searchText)
  }
}

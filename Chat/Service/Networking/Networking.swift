//
//  Networking.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
import Starscream

struct Networking {
  
  // MARK: - Properties
  
  static let shared = Networking(
    session: .shared,
    responseQueue: .main,
    tokenKeychain: TokenKeychain())
  
  let session: URLSession
  let responseQueue: DispatchQueue?
  let tokenKeychain: TokenKeychain
  
  // MARK: - init
  
  init(
    session: URLSession,
    responseQueue: DispatchQueue?,
    tokenKeychain: TokenKeychain
  ) {
    self.session = session
    self.responseQueue = responseQueue
    self.tokenKeychain = tokenKeychain
  }
  
  // MARK: - Funcs
  
  func login(
    email: String,
    password: String,
    completion: @escaping (Result<User, Error>) -> Void
  ) {
    
    precondition(!email.isEmpty, "Email must not be empty")
    precondition(!password.isEmpty, "Password must not be empty")
    
    let combined = "\(email):\(password)"
    
    guard let data = combined.data(using: .utf8) else {
      fatalError("Failed to create data from creadentials")
    }
    
    let hash = data.base64EncodedString()
    
    session.request(.login(withHash: hash)) { data, response, error in
      
      if let error = error {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
        return
      }
      
      let status = self.getStatus(from: response)
      
      guard status == .success else {
        // TODO: check for cases

        self.dispatchResult(
          .failure(.unknown),
          completion: completion)

        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(.noData),
          completion: completion)
        return
      }
      
      do {
        let loginData: LoginData = try self.decode(data: data)
        let token = Token(hash: loginData.token)
        
        try TokenKeychain().store(token)
        
        self.dispatchResult(
          .success(loginData.user),
          completion: completion)
        
      } catch {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
      }
      
    }
  }
  
  func logout(completion: @escaping (Error?) -> Void) {
    
    let token: Token
    
    do {
      token = try tokenKeychain.retrieve()
    } catch {
      completion(.system(error))
      return
    }
    
    session.request(.logout(withHash: token.hash)) { _, response, error in
      
      if let error = error {
        self.dispatchError(
          .system(error),
          completion: completion)
        return
      }
      
      let status = self.getStatus(from: response)
      
      guard status == .success else {
        // TODO: check for cases
        
        self.dispatchError(
          .unknown,
          completion: completion)
        
        return
      }
      
      self.dispatchError(nil, completion: completion)
    }
  }
  
  func register(
    with userData: RegisterUserData,
    completion: @escaping (Result<User, Error>) -> Void
  ) {
    
    let encodedUserData: Data
    
    do {
      encodedUserData = try JSONEncoder().encode(userData)
    } catch {
      fatalError("Failed to encode RegisterUserData")
    }
    
    session.request(.register(with: encodedUserData)) { data, response, error in
      
      if let error = error {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
        return
      }
      
      let status = self.getStatus(from: response)
      
      guard status == .success else {
        // TODO: check for cases
        
        self.dispatchResult(
          .failure(.unknown),
          completion: completion)
        
        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(.noData),
          completion: completion)
        return
      }
      
      do {
        let user: User = try self.decode(data: data)
        
        self.dispatchResult(
          .success(user),
          completion: completion)
        
      } catch {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
      }
    }
  }
  
  func saveNotificationToken(
    _ apnsToken: String,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    
    let token: Token
    
    do {
      token = try tokenKeychain.retrieve()
    } catch {
      completion(.failure(.system(error)))
      return
    }
    
    session.request(.saveNotificationToken(apnsToken, hash: token.hash)) { data, response, error in
      
      if let error = error {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
        return
      }
      
      let status = self.getStatus(from: response)
      
      guard status == .success else {
        // TODO: check for cases
        
        self.dispatchResult(
          .failure(.unknown),
          completion: completion)
        
        return
      }
      
      self.dispatchResult(.success(()), completion: completion)
    }
  }
  
  func saveUsername(
    _ username: String,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    
    let token: Token
    
    do {
      token = try tokenKeychain.retrieve()
    } catch {
      completion(.failure(.system(error)))
      return
    }
    
    session.request(.update(username: username, hash: token.hash)) { data, response, error in
      
      if let error = error {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
        return
      }
      
      let status = self.getStatus(from: response)
      
      guard status == .success else {
        // TODO: check for cases
        
        self.dispatchResult(
          .failure(.unknown),
          completion: completion)
        
        return
      }
      
      self.dispatchResult(.success(()), completion: completion)
    }
  }
  
  func savePassword(
    _ password: String,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    
    let token: Token
    
    do {
      token = try tokenKeychain.retrieve()
    } catch {
      completion(.failure(.system(error)))
      return
    }
    
    session.request(.update(password: password, hash: token.hash)) { data, response, error in
      
      if let error = error {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
        return
      }
      
      let status = self.getStatus(from: response)
      
      guard status == .success else {
        // TODO: check for cases
        
        self.dispatchResult(
          .failure(.unknown),
          completion: completion)
        
        return
      }
      
      self.dispatchResult(.success(()), completion: completion)
    }
  }
  
  func searchUsers(
    with name: String,
    completion: @escaping (Result<[User], Error>) -> Void
  ) {
    
    // TODO: refactor getting token to separate func
    
    let token: Token
    
    do {
      token = try tokenKeychain.retrieve()
    } catch {
      completion(.failure(.system(error)))
      return
    }
    
    session.request(.searchUsers(with: name, hash: token.hash)) { data, response, error in
      
      if let error = error {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
        return
      }
      
      let status = self.getStatus(from: response)
      
      guard status == .success else {
        // TODO: check for cases
        
        self.dispatchResult(
          .failure(.unknown),
          completion: completion)
        
        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(.noData),
          completion: completion)
        return
      }
      
      do {
        let users: [User] = try self.decode(data: data)
        
        self.dispatchResult(
          .success(users),
          completion: completion)
        
      } catch {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
      }
    }
  }
  
  func fetchChats(completion: @escaping (Result<[Chat], Error>) -> Void) {
    
    let token: Token
    
    do {
      token = try tokenKeychain.retrieve()
    } catch {
      completion(.failure(.system(error)))
      return
    }
    
    session.request(.fetchChats(hash: token.hash)) { data, response, error in
      
      if let error = error {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
        return
      }
      
      let status = self.getStatus(from: response)
      
      guard status == .success else {
        // TODO: check for cases
        
        self.dispatchResult(
          .failure(.unknown),
          completion: completion)
        
        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(.noData),
          completion: completion)
        return
      }
      
      do {
        let chats: [Chat] = try self.decode(data: data)
        
        self.dispatchResult(
          .success(chats),
          completion: completion)
        
      } catch {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
      }
    }
  }
  
  func fetchChat(
    with user: User,
    completion: @escaping (Result<Chat, Error>) -> Void
  ) {
   
    let token: Token
    
    do {
      token = try tokenKeychain.retrieve()
    } catch {
      completion(.failure(.system(error)))
      return
    }
    
    session.request(.fetchChat(with: user, hash: token.hash)) { data, response, error in
      
      if let error = error {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
        return
      }
      
      let status = self.getStatus(from: response)
      
      guard status == .success else {
        // TODO: check for cases
        
        self.dispatchResult(
          .failure(.unknown),
          completion: completion)
        
        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(.noData),
          completion: completion)
        return
      }
      
      do {
        let chat: Chat = try self.decode(data: data)
        
        self.dispatchResult(
          .success(chat),
          completion: completion)
        
      } catch {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
      }
    }
  }
  
  func fetchMessages(
    for chat: Chat,
    completion: @escaping (Result<[Message], Error>) -> Void
  ) {
    
    let token: Token
    
    do {
      token = try tokenKeychain.retrieve()
    } catch {
      completion(.failure(.system(error)))
      return
    }
    
    session.request(.messages(for: chat, hash: token.hash)) { data, response, error in
      
      if let error = error {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
        return
      }
      
      let status = self.getStatus(from: response)
      
      guard status == .success else {
        // TODO: check for cases
        
        self.dispatchResult(
          .failure(.unknown),
          completion: completion)
        
        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(.noData),
          completion: completion)
        return
      }
      
      do {
        let messages: [Message] = try self.decode(data: data)
        
        self.dispatchResult(
          .success(messages),
          completion: completion)
        
      } catch {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
      }
    }
  }
  
  func makeWebSocket(
    for chat: Chat,
    delegate: WebSocketDelegate
  ) throws -> WebSocket {
    
    let token = try tokenKeychain.retrieve()
    
    let request = Endpoint.messagesSocket(for: chat, hash: token.hash).request
    let websocket = WebSocket(request: request)
    websocket.delegate = delegate
    return websocket
  }
  
  func downloadImage(
    from url: URL,
    completion: @escaping (Result<Data, Error>) -> Void
  ) {
    
    let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
    
    let task = session.dataTask(with: request) { data, _, _ in
      
      guard let data = data else {
        completion(.failure(.noData))
        return
      }
      
      completion(.success(data))
    }
    
    task.resume()
  }
  
  func upload(avatarData: Data, completion: @escaping (Result<String, Error>) -> Void) {
    
    let token: Token
    
    do {
      token = try tokenKeychain.retrieve()
    } catch {
      completion(.failure(.system(error)))
      return
    }
    
    session.request(.save(avatarData: avatarData, hash: token.hash)) { data, response, error in
      
      if let error = error {
        self.dispatchResult(
          .failure(.system(error)),
          completion: completion)
        return
      }
      
      let status = self.getStatus(from: response)
      
      guard status == .success else {
        // TODO: check for cases
        
        self.dispatchResult(
          .failure(.unknown),
          completion: completion)
        
        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(.noData),
          completion: completion)
        return
      }
      
      guard let urlString = String(data: data, encoding: .utf8) else {
        self.dispatchResult(
          .failure(.noData),
          completion: completion)
        return
      }
      
      self.dispatchResult(
        .success(urlString),
        completion: completion)
    }
  }
  
}

// MARK: - Helpers
extension Networking {
  
  enum Error: LocalizedError {
    case noData
    case system(Swift.Error)
    case unknown
    
    var errorDescription: String? {
      
      switch self {
        
        case .noData:
          return "No data"
        
        case .system(let error):
          return error.localizedDescription
        
        case .unknown:
          return "Unknown error"
      }
    }
  }
  
  private func getStatus(from response: URLResponse?) -> HTTPReponseStatus {
    
    guard let response = response as? HTTPURLResponse else {
      return .unknownResponse
    }
    
    switch response.statusCode {
      case 200...299:
        return .success
      case 400...499:
        return .clientError
      case 500...599:
        return .serverError
      case 600:
        return .timeout
      default:
        return .unknownResponse
    }
  }
  
  private func dispatchResult<Type>(
    _ result: Result<Type, Error>,
    completion: @escaping (Result<Type, Error>) -> Void
  ) {
    
    guard let responseQueue = self.responseQueue else {
      completion(result)
      return
    }
    responseQueue.async {
      completion(result)
    }
  }
  
  private func dispatchError(
    _ error: Error?,
    completion: @escaping (Error?) -> Void
  ) {
    
    guard let responseQueue = self.responseQueue else {
      completion(error)
      return
    }
    responseQueue.async {
      completion(error)
    }
  }
  
  private func decode<T: Decodable>(
    data: Data,
    decoder: JSONDecoder = JSONDecoder()
  ) throws -> T {
    
    decoder.dateDecodingStrategy = .iso8601
    
    let result = try decoder.decode(
      T.self,
      from: data)
    
    return result
  }
}

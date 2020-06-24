//
//  Endpoint.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 30.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct Endpoint {
  var scheme: HTTPScheme = .https
  var path: String
  var httpMethod: HTTPMethod = .get
  var queryItems: [URLQueryItem] = []
  var httpHeaders: [HTTPHeader] = []
  var httpBody: Data?
  var version: APIVersion = .v0
}

extension Endpoint {
  
  var url: URL {
    var components = URLComponents()
    var scheme = self.scheme
    
    #if DEBUG
    if scheme != .ws { scheme = .http }
    components.host = "localhost"
    components.port = 8080
    #else
    if scheme != .ws { scheme = .https }
    components.host = "vapor-chat-server-url.com"
    #endif
    
    components.scheme = scheme.rawValue
    components.path = "/" + version.rawValue + "/" + path
    components.queryItems = queryItems
    
    guard let url = components.url else {
      preconditionFailure(
        "Invalid URL components: \(components)")
    }
    
    return url
  }
  
  var request: URLRequest {
    
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue.uppercased()
    request.httpBody = httpBody
    
    for header in httpHeaders {
      request.addHeader(header)
    }
    
    return request
  }
  
  private static func photoDataToFormData(data: Data, boundary: String, fileName: String) -> Data {

    var fullData = Data()

    let lineOne = "--" + boundary + "\r\n"
    fullData.append(lineOne.data(using: .utf8, allowLossyConversion: false)!)

    let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"\(fileName)\"\r\n"

    fullData.append(lineTwo.data(using: .utf8, allowLossyConversion: false)!)

    let lineThree = "Content-Type: image/jpg\r\n\r\n"
    fullData.append(lineThree.data(using: .utf8, allowLossyConversion: false)!)

    fullData.append(data as Data)

    let lineFour = "\r\n"
    fullData.append(lineFour.data(using: .utf8, allowLossyConversion: false)!)

    let lineFive = "--" + boundary + "--\r\n"
    fullData.append(lineFive.data(using: .utf8, allowLossyConversion: false)!)

    return fullData
  }
  
}

extension Endpoint {
  
  static func login(withHash hash: String) -> Self {
    
    Endpoint(
      path: "sign-in",
      httpMethod: .get,
      httpHeaders: [
        .authorization(type: .basic, hash: hash)])
  }
  
  static func logout(withHash hash: String) -> Self {
    
    Endpoint(
      path: "sign-out",
      httpHeaders: [
        .authorization(type: .bearer, hash: hash)])
  }
  
  static func register(with userData: Data) -> Self {
    
    Endpoint(
      path: "users",
      httpMethod: .post,
      httpHeaders: [.contentType(value: .applicationJson)],
      httpBody: userData)
  }
  
  static func searchUsers(with name: String, hash: String) -> Self {
    
    Endpoint(
      path: "users/search/\(name)",
      httpHeaders: [
        .authorization(type: .bearer, hash: hash)])
  }
  
  static func fetchChats(hash: String) -> Self {
    
    Endpoint(
      path: "chats",
      httpHeaders: [
        .authorization(type: .bearer, hash: hash)])
  }
  
  static func fetchChat(with user: User, hash: String) -> Self {
    
    Endpoint(
      path: "chats/\(user.id)",
      httpHeaders: [
        .authorization(type: .bearer, hash: hash)])
  }
  
  static func saveNotificationToken(_ token: String, hash: String) -> Self {
    
    Endpoint(
      path: "users/notification-token/\(token)",
      httpHeaders: [
        .authorization(type: .bearer, hash: hash)])
  }
  
  static func messages(for chat: Chat, hash: String) -> Self {
    
    Endpoint(
      path: "messages/\(chat.id)",
      httpHeaders: [
        .authorization(type: .bearer, hash: hash)])
  }
  
  static func messagesSocket(for chat: Chat, hash: String) -> Self {
    
    Endpoint(
      scheme: .ws,
      path: "messages/socket/\(chat.id)",
      httpHeaders: [
        .authorization(type: .bearer, hash: hash)])
  }
  
  static func save(avatarData: Data, hash: String) -> Self {
    
    let imageName = UUID().uuidString + ".jpg"
    let boundary = UUID().uuidString
    let data = photoDataToFormData(data: avatarData, boundary: boundary, fileName: imageName)
    
    return Endpoint(
      path: "users/avatar/",
      httpMethod: .post,
      httpHeaders: [
        .authorization(type: .bearer, hash: hash),
        .contentType(value: .multipartFormData(boundary: boundary)),
        .contentLength(data.count)
      ],
      httpBody: data)
  }
  
  static func update(username: String, hash: String) -> Self {
    
    Endpoint(
      path: "users/username/\(username)",
      httpHeaders: [
        .authorization(type: .bearer, hash: hash)])
  }
  
  static func update(password: String, hash: String) -> Self {
    
    Endpoint(
      path: "users/password/\(password)",
      httpHeaders: [
        .authorization(type: .bearer, hash: hash)])
  }
}

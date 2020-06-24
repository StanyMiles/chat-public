//
//  AppDelegate.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    UNUserNotificationCenter.current().delegate = self
    registerForPushNotifications()
    
    return true
  }

  // MARK: - UISceneSession Lifecycle

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    
    guard let chatId = userInfo["chatId"] as? String else {
      completionHandler(.failed)
      return
    }
    
    setUnreadBadgeOnChat(with: chatId)
    
    completionHandler(.newData)
  }
  
  
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    
    do {
      try APNTokenKeychain().store(token)
    } catch {
      print("Failed to store APNToken in keychain:", error.localizedDescription)
    }
    
    Networking.shared.saveNotificationToken(token) { result in
      
      switch result {
        
        case .success:
          print("Saved token to Server")
        
        case .failure(let error):
          print("Failed to save token to Server:", error.localizedDescription)
      }
    }
  }
  
  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    
    print("Failed to register for remote notifications:", error.localizedDescription)
  }
  
  // MARK: - Helpers
  
  private func registerForPushNotifications() {
    
    UNUserNotificationCenter
      .current()
      .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
        
        guard let self = self else { return }
        guard granted else { return }
        self.getNotificationSettings()
    }
  }
  
  private func getNotificationSettings() {
    
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      
      guard settings.authorizationStatus == .authorized else { return }
      
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
  
  private func setUnreadBadgeOnChat(with id: String) {
    
    NotificationCenter
      .default
      .post(
        name: .didReceiveMessage,
        object: nil,
        userInfo: ["chatId": id])
  }
  
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    
//    print("Did receive notification on opening")
    
    let userInfo = response.notification.request.content.userInfo
    
    if let chatId = userInfo["chatId"] as? String {
      setUnreadBadgeOnChat(with: chatId)
    }
    
    completionHandler()
  }
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    
    let userInfo = notification.request.content.userInfo
    
    if let chatId = userInfo["chatId"] as? String {
      setUnreadBadgeOnChat(with: chatId)
    }
    
    completionHandler([.alert, .sound])
  }
}

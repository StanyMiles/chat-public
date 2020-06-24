//
//  SettingsController.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var avatarImageView: UIImageView!
  @IBOutlet private weak var usernameTextField: UITextField!
  @IBOutlet private weak var newPasswordTetxField: UITextField!
  @IBOutlet private weak var confirmPasswordTextField: UITextField!
  
  // MARK: - Properties
  
  var networking: Networking = .shared
  var photoPicker = PhotoPicker()
  
  private lazy var user: User = {
    do {
      return try UserKeychain().retrieve()
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupFields()
  }
  
  // MARK: - IBActions
  
  @IBAction
  private func handleSignOut(_ sender: Any) {
    
    Networking.shared.logout { [weak self] _ in
      
      guard let self = self else { return }
      
      try? TokenKeychain().remove()
      try? UserKeychain().remove()
 
      self.coordinator.signOut()
    }
  }
  
  @IBAction
  private func selectPhoto(_ sender: Any) {
    
    photoPicker.present(in: self) { [unowned self] image in
      self.compressAndSet(image)
    }
  }
  
  // MARK: - Funcs
  
  private func setupFields(imageLoader: ImageLoader = .shared) {
    
    usernameTextField.text = user.username
    
    guard let avatarURL = user.avatarURL else { return }
    
    imageLoader.downloadImage(from: avatarURL) { [weak self] image in
      guard let self = self else { return }
      self.avatarImageView.image = image
    }
  }
  
  private func compressAndSet(_ image: UIImage) {
    
    DispatchQueue.global().async {
      
      let compressed = image.resize()
      guard let imageData = compressed.jpegData(compressionQuality: 1) else { return }
      
      self.networking.upload(avatarData: imageData) { [weak self] result in
        
        guard let self = self else { return }
        
        switch result {
          
          case .success(let avatarUrlString):
            self.avatarImageView.image = compressed
            self.updateUser(avatarUrlString: avatarUrlString)
          
          case .failure(let error):
            print("Failed to save avatar to Server:", error.localizedDescription)
        }
      }
    }
  }
  
  private func updateUser(avatarUrlString: String) {
    
    user.avatarUrlString = avatarUrlString
    
    do {
      try UserKeychain().store(user)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  private func updateUser(username: String) {
    
    user.username = username
    
    do {
      try UserKeychain().store(user)
      presentAlert(title: "Saved", message: nil)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  private func saveUsername() {
    
    guard let username = usernameTextField.text, !username.isEmpty else { return }
    guard user.username != username else { return }
    
    networking.saveUsername(username) { [weak self] result in
      
      guard let self = self else { return }
      
      switch result {
        
        case .success:
          self.updateUser(username: username)
        
        case .failure(let error):
          print("Faield to save username to Server", error.localizedDescription)
      }
    }
  }
  
  private func savePassword() {
    
    guard let password = newPasswordTetxField.text, !password.isEmpty else { return }
    guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else { return }
    
    guard password == confirmPassword else {
      presentAlert(title: "Passwords don't match", message: nil)
      return
    }
    
    newPasswordTetxField.text = nil
    confirmPasswordTextField.text = nil
    
    networking.savePassword(password) { [weak self] result in
      
      guard let self = self else { return }
      
      switch result {
        
        case .success:
          self.presentAlert(title: "Saved", message: nil)
        
        case .failure(let error):
          self.presentAlert(
            title: "Faield to save password to Server",
            message: error.localizedDescription)
      }
    }
  }
}

// MARK: - UITextFieldDelegate
extension SettingsController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    switch textField {
      
      case usernameTextField:
        saveUsername()
      
      case newPasswordTetxField:
        confirmPasswordTextField.becomeFirstResponder()
      
      case confirmPasswordTextField:
        savePassword()
      
      default: break
    }
    
    return true
  }
}

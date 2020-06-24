//
//  LoginController.swift
//  Chat
//
//  Created by Stanislav Kobiletski on 17.05.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
  
  private enum State: Int {
    case signIn, registration
  }

  // MARK: - IBOutlets
  
  @IBOutlet
  private weak var segmentedControl: UISegmentedControl!
  
  @IBOutlet
  private weak var usernameTextField: UITextField!
  
  @IBOutlet
  private weak var emailTextField: UITextField!
  
  @IBOutlet
  private weak var passwordTextField: UITextField!
  
  @IBOutlet
  private weak var confirmPasswordTextField: UITextField!
  
  @IBOutlet
  private weak var signInButton: UIButton!
  
  // MARK: - Properties
  
  private var state: State {
    State(rawValue: segmentedControl.selectedSegmentIndex) ?? .signIn
  }
  
  var networking: Networking = .shared
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews(for: .signIn)
  }

  // MARK: - IBActions
  
  @IBAction
  private func handleSignIn(_ sender: Any) {
    //TODO: check fields for empty + email + pass length == 6
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    switch state {
      
      case .signIn:
        
        handleSignIn(email: email, password: password)
      
      case .registration:
        
        guard let username = usernameTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextField.text else { return }
        
        let userData = RegisterUserData(
          username: username,
          email: email,
          password: password,
          confirmPassword: confirmPassword)
        
        handleRegister(with: userData)
    }
  }
  
  @IBAction
  private func handleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
    setupViews(for: state)
  }
  
  // MARK: - Funcs

  private func setupViews(for state: State) {
    
    let isSignIn = state == .signIn

    usernameTextField.isHidden = isSignIn
    confirmPasswordTextField.isHidden = isSignIn
    
    let title = isSignIn ? "Sign In" : "Register"
    signInButton.setTitle(title, for: .normal)
    
    if isSignIn && usernameTextField.isFirstResponder {
      emailTextField.becomeFirstResponder()
    }
  }
  
  private func handleSignIn(email: String, password: String) {
    
    hideKeyboard()
    
    networking.login(email: email, password: password) { [weak self] result in
      
      guard let self = self else { return }
      self.handleSignInResult(result)
    }
  }
  
  private func handleRegister(with userData: RegisterUserData) {
    
    hideKeyboard()
    
    networking.register(with: userData) { [weak self] result in
      
      guard let self = self else { return }
      
      switch result {
        
        case .success:
        
          self.networking.login(
            email: userData.email,
            password: userData.password
          ) { result in
            
            self.handleSignInResult(result)
          }
        
        case .failure(let error):
          self.presentAlert(
            title: "Failed to Register",
            message: error.localizedDescription)
      }
    }
  }
  
  private func handleSignInResult(_ result: Result<User, Networking.Error>) {
    
    switch result {
      
      case .success(let user):
        
        do {
          try UserKeychain().store(user)
        } catch {
          fatalError(error.localizedDescription)
        }
        
        self.resaveAPNToken()
        self.coordinator.presentSplitController()
      
      case .failure(let error):
        self.presentAlert(
          title: "Failed to Sign In",
          message: error.localizedDescription)
    }
  }
  
  private func resaveAPNToken() {
    
    do {
      let token = try APNTokenKeychain().retrieve()
      
      networking.saveNotificationToken(token) { result in
        
        switch result {
          
          case .success:
            print("Saved token to Server")
          
          case .failure(let error):
            print("Failed to save token to Server:", error.localizedDescription)
        }
      }
      
    } catch {
      print("Failed to retrieve APNToken from keychain:", error.localizedDescription)
    }
  }
  
}

// MARK: - Storyboarded
extension LoginController: Storyboarded {}

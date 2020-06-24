//
//  PhotoPicker.swift
//  B-Counter
//
//  Created by Stanislav Kobiletski on 30.04.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class PhotoPicker: NSObject {
  
  typealias PhotoCompletion = (UIImage) -> Void
  
  fileprivate var completion: PhotoCompletion?
  
  lazy var picker: UIImagePickerController = {
    let picker = UIImagePickerController()
    picker.allowsEditing = false
    picker.delegate = self
    return picker
  }()
  
  func present(
    in viewController: UIViewController,
    title: String? = "Add Photo",
    message: String? = nil,
    sourceView: UIView? = nil,
    completion: @escaping PhotoCompletion
  ) {
  
    self.completion = completion
    
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      
      let presentCamera = UIAlertAction(
        title: "Camera",
        style: .default
      ) { _ in
        self.presentCamera(in: viewController)
      }
      
      alert.addAction(presentCamera)
    }
    
    let presentLibrary = UIAlertAction(
      title: "Photo Library",
      style: .default
    ) { _ in
      self.presentPhotoLibrary(in: viewController)
    }
    
    alert.addAction(presentLibrary)
    alert.addAction(.cancel)
    
    if let view = sourceView,
      let popoverController = alert.popoverPresentationController {
      let rect = CGRect(
        x: view.frame.midX,
        y: view.frame.midY,
        width: 0,
        height: 0)
      popoverController.sourceRect = rect
      popoverController.sourceView = view
    }
    
    viewController.present(alert, animated: true)
  }
  
}

fileprivate extension PhotoPicker {
  
  func presentCamera(in viewController: UIViewController) {
    picker.sourceType = .camera
    viewController.present(picker, animated: true)
  }
  
  func presentPhotoLibrary(in viewController: UIViewController) {
    picker.sourceType = .photoLibrary
    viewController.present(picker, animated: true)
  }
  
}

// MARK: - UIImagePickerControllerDelegate
extension PhotoPicker: UIImagePickerControllerDelegate {
  
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    
    if let image = info[.editedImage] as? UIImage {
      completion?(image)
    } else if let image = info[.originalImage] as? UIImage {
      completion?(image)
    }
    
    picker.dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }
  
}

// MARK: - UINavigationControllerDelegate
extension PhotoPicker: UINavigationControllerDelegate {}

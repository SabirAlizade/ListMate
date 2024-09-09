//
//  Controller+Ext.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

protocol ImagePickerDelegate: AnyObject {
    func didSelectImage(_ image: UIImage, isEdited: Bool)
}

extension UIViewController {
    
    // MARK: - Alerts
    
    func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        okAction.setValue(UIColor.mainGreen, forKey: "titleTextColor")
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func showPermissionDeniedAlert(for resource: String) {
        let alert = UIAlertController(
            title: "\(resource) Access Denied",
            message: "Please enable access to the \(resource.lowercased()) in Settings.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            }
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - UI
    
    func customBackgroundColor() {
        self.view.backgroundColor = .mainGray
    }
    
    func stopActivityIndicator() {
        ActivityIndicator.shared.stopActivityIndicator()
    }
}

// MARK: - Image Picker Handling

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            alertMessage(
                title: LanguageBase.imagePicker(.sourceAlarmTitle).translate,
                message: LanguageBase.imagePicker(.sourceAlarmBody).translate
            )
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true) {
            self.stopActivityIndicator()
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        var isEdited = false
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            isEdited = true
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if let image = selectedImage {
            handleSelectedImage(image, isEdited: isEdited)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func handleSelectedImage(_ image: UIImage, isEdited: Bool) {
        if let imagePickerDelegate = self as? ImagePickerDelegate {
            imagePickerDelegate.didSelectImage(image, isEdited: isEdited)
        }
    }
    
    @objc
    func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePC = UIImagePickerController()
            imagePC.sourceType = .camera
            imagePC.allowsEditing = true
            imagePC.delegate = self
            present(imagePC, animated: true)
        }
    }
}

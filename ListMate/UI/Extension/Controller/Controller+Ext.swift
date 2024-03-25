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
    
    func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        okAction.setValue(UIColor.maingreen, forKey: "titleTextColor")
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func customBackgroundColor() {
        self.view.backgroundColor = .maingray
    }
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            alertMessage(title: LanguageBase.imagePicker(.sourceAlarmTitle).translate, message: LanguageBase.imagePicker(.sourceAlarmBody).translate)
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
    
    func stopActivityIndicator() {
           ActivityIndicator.shared.stopActivityIndicator()
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

//
//  ImagePreviewViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 27.12.23.
//

import UIKit

protocol ImagePreviewDelegate: AnyObject {
    func updateImage(image: UIImage)
}

class ImagePreviewViewController: BaseViewController {
    
    weak var delegate: ImagePreviewDelegate?
    
    var itemImage: UIImage?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.itemImage
        return imageView
    }()
    
    private lazy var choosePicButton = CustomButton(title: "Choose photo",
                                                    backgroundColor: .black,
                                                    titleColor: .white,
                                                    target: self,
                                                    action: #selector(presentPicker))
    
    private lazy var takephotoButton = CustomButton(title: "Take photo",
                                                    backgroundColor: .black,
                                                    titleColor: .white,
                                                    target: self,
                                                    action: #selector(takePicture))
    
    override func setupUIComponents() {
        super.setupUIComponents()
        view.backgroundColor = .black
        closeBarButton()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
       // configureGestures()
    }
    
    private func setupUI() {
        let hStack = UIView().HStack(views: takephotoButton, choosePicButton, spacing: 120, distribution: .fill)
        
        view.anchorFill(view: imageView, safe: true)
        view.anchor(view: hStack) { kit in
            kit.bottom(10, safe: true)
            kit.trailing(10)
            kit.leading(10)
            kit.height(35)
        }
    }
    
//    @objc
//    private func pinchGesture(_ sender: UIPinchGestureRecognizer) {
//        guard let view = sender.view else { return }
//        if sender.state == .changed || sender.state == .ended {
//            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
//            sender.scale = 1.0
//        }
//    }
//    
//    private func configureGestures() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
//        imageView.addGestureRecognizer(tapGesture)
//        
//        //            let pinchGesture = UIPinchGestureRecognizer(target: self, action: pinchHandling)
//        //            imageView.addGestureRecognizer(pinchGesture)
//    }
//    
    
    @objc
    private func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePC = UIImagePickerController()
            imagePC.sourceType = .camera
            imagePC.allowsEditing = true
            imagePC.delegate = self
            present(imagePC, animated: true)
        } else {
            print("Camera is not available")
        }
    }
    
    @objc
    private func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc
    private func savePicture() {
        guard let itemImage else { return }
        UserDefaults.standard.saveImage(image: itemImage, key: itemImage.description)
        delegate?.updateImage(image: itemImage)
    }
}

extension ImagePreviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            itemImage = imageSelected
            imageView.image = imageSelected
            choosePicButton.isHidden = true
            imageView.isHidden = false
            savePicture()
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            itemImage = imageOriginal
            imageView.image = imageOriginal
        }
        picker.dismiss(animated: true)
    }
}





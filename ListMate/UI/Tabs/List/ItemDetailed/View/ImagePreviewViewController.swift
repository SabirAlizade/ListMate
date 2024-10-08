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
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var activityIndicator: ActivityIndicator = {
        return ActivityIndicator.shared
    }()
    
    // MARK: - Setup UI
    
    override func setupUIComponents() {
        super.setupUIComponents()
        view.backgroundColor = .black
        closeBarButton()
        configureEditBarButton()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
        configureGestures()
    }
    
    private func setupUI() {
        view.anchorFill(view: imageView, safe: true)
    }
    
    private func configureEditBarButton() {
        let menuItems = imagePickerButtons(takePictureAction: takePicture, presentPickerAction: presentPicker)
        let editButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil.circle"), menu: menuItems)
        editButtonItem.tintColor = .mainGreen
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    // MARK: - Gestures
    
    @objc
    private func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        guard let view = sender.view else { return }
        if sender.state == .changed || sender.state == .ended {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1.0
        }
        if sender.state == .ended {
            let currentScale = view.frame.size.width / view.bounds.size.width
            if currentScale < 1.0 {
                UIView.animate(withDuration: 0.3) {
                    view.transform = .identity
                }
            }
        }
    }
    
    private func configureGestures() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        imageView.addGestureRecognizer(pinchGesture)
    }
    
    // MARK: - Image Actions
    
    @objc
    private func takePicture() {
        PermissionManager.shared.requestCameraPermission(from: self) { [weak self] granted in
            if granted {
                self?.presentImagePicker(sourceType: .camera)
            }
        }
    }
    
    @objc
    private func presentPicker() {
        PermissionManager.shared.requestPhotoLibraryPermission(from: self) { [weak self] granted in
            if granted {
                self?.presentImagePicker(sourceType: .photoLibrary)
            }
        }
    }
    
    @objc
    private func saveImage() {
        guard let selectedImage = imageView.image else { return }
        delegate?.updateImage(image: selectedImage)
    }
}

extension ImagePreviewViewController: ImagePickerDelegate {
    func didSelectImage(_ image: UIImage, isEdited: Bool) {
        imageView.image = image
        if isEdited {
            imageView.isHidden = false
            saveImage()
        }
    }
}



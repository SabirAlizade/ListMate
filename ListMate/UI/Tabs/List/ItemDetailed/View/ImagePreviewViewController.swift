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
        return imageView
    }()
    
    //    private lazy var choosePicButton = CustomImageButton(image: UIImage(systemName: "photo.on.rectangle"),
    //                                                         tintColor: .white,
    //                                                         backgroundColor: .black,
    //                                                         target: self,
    //                                                         action: #selector(presentPicker))
    //
    //    private lazy var takephotoButton = CustomImageButton(image: UIImage(systemName: "camera"),
    //                                                         tintColor: .white,
    //                                                         backgroundColor: .black,
    //                                                         target: self,
    //                                                         action: #selector(takePicture))
    
    //
    //    private lazy var editButton = CustomImageButton(image: UIImage(systemName: "pencil.circle"),
    //                                                         tintColor: .white,
    //                                                         backgroundColor: .black,
    //                                                         target: self,
    //                                                         action: #selector(rightBarButtonTapped))
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage( UIImage(systemName: "pencil.circle"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        view.backgroundColor = .black
        closeBarButton()
        //        configureBarButton()
        configBarButtn()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
        
        // configureGestures()
    }
    
    private func setupUI() {
        view.anchorFill(view: imageView, safe: true)
        //        view.anchor(view: takephotoButton) { kit in
        //            kit.bottom(10, safe: true)
        //            kit.leading(10)
        //            kit.width(30)
        //            kit.height(30)
        //        }
        //
        //        view.anchor(view: choosePicButton) { kit in
        //            kit.bottom(10, safe: true)
        //            kit.trailing(10)
        //            kit.width(30)
        //            kit.height(30)
        //        }
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
    
   private  func configBarButtn(){
        let menuItems = imagePickerButtons(takePictureAction: takePicture, presentPickerAction: presentPicker)
        let editButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil.circle"),
                                             menu: menuItems)
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
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
        guard let selected = imageView.image else { return }
       // UserDefaults.standard.saveImage(image: selected, key: selected.description)
        delegate?.updateImage(image: selected)
    }
}

extension ImagePreviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = imageSelected
            //   choosePicButton.isHidden = true
            imageView.isHidden = false
          //  savePicture()
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = imageOriginal
        }
        picker.dismiss(animated: true)
    }
}





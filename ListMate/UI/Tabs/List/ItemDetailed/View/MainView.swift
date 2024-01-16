//
//  MainView.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func updateNameAndNote(name: String, note: String)
    func openImage(image: UIImage)
}

final class MainView: BaseView {
    weak var delegate: MainViewDelegate?
    
    private var itemImage: UIImage?
    
    var item: ItemModel? {
        didSet {
            guard let item else { return }
            nameTextField.text = item.name
            noteTextField.text = item.notes
            if let image = UserDefaults.standard.readImage(key: item.image) {
                itemImage = image
                itemImageView.image = image
            }
        }
    }
    
    private let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var nameTextField = CustomTextField(placeHolder: "Set name",
                                                     font: .poppinsFont(size: 22, weight: .medium),
                                                     border: .none,
                                                     target: self,
                                                     action: #selector(didTapValueChanged))
    
    private lazy var noteTextField = CustomTextField(placeHolder: "Add note",
                                                     font: .poppinsFont(size: 18, weight: .light),
                                                     border: .none,
                                                     target: self,
                                                     action: #selector(didTapValueChanged))
    
     lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var itemImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkText
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(presentPicker), for: .touchUpInside)
        return button
    }()
    
    override func setupView() {
        super.setupView()
        setupUI()
    }
    
    //MARK: IF PICTURE IS STANDART SHOULD AVOID PREVIEW AND PICK PICTURE INSTEAD
    
    private func setupUI() {
        nameTextField.customizeBorder(width: nil, color: nil)
        noteTextField.customizeBorder(width: nil, color: nil)
        
        self.anchorFill(view: mainView)
        
        mainView.anchor(view: itemImageView) { kit in
            kit.leading(10)
            kit.centerY()
            kit.height(60)
            kit.width(60)
        }
        
        mainView.anchor(view: itemImageButton) { kit in
            kit.leading(10)
            kit.centerY()
            kit.height(60)
            kit.width(60)
        }
        
        mainView.anchor(view: nameTextField) { kit in
            kit.leading(itemImageButton.trailingAnchor, 10)
            kit.top(13)
        }
        
        mainView.anchor(view: noteTextField) { kit in
            kit.leading(nameTextField)
            kit.bottom(13)
        }
    }
    
    @objc
    private func presentPicker() {
        guard let itemImage else { return }
            delegate?.openImage(image: itemImage)
        }
//    }
//    @objc
//    private func presentPicker() {
////        guard let itemImage = itemImage else { return }
////
////      //  let cameraCircleImage = UIImage(systemName: "camera.circle")
////        let choosePhotoImage = UIImage(named: "choosePhoto")
////
////        if itemImage.pngData() == (cameraCircleImage ?? UIImage()).pngData() {
////            delegate?.openImage(image: choosePhotoImage ?? itemImage)
////        } else {
////            delegate?.openImage(image: itemImage)
////        }
//    }
    
    @objc
    private func didTapValueChanged() {
        guard let name = nameTextField.text else { return }
        guard let note = noteTextField.text else { return }
        delegate?.updateNameAndNote(name: name, note: note)
    }
}
//
//extension MainView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            itemImage = imageSelected
//            itemImageView.image = imageSelected
//            itemImageButton.isHidden = true
//            itemImageView.isHidden = false
//        }
//
//        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            itemImage = imageOriginal
//            itemImageView.image = imageOriginal
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//}

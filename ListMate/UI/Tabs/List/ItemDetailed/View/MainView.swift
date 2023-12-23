//
//  MainView.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import UIKit

class MainView: BaseView {
    
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
                                                     action: #selector(didTapChangeName)
    )
    
    private lazy var noteTextField = CustomTextField(placeHolder: "Add note",
                                                     font: .poppinsFont(size: 18, weight: .light),
                                                     border: .none,
                                                     target: self,
                                                     action: #selector(didTapAddNote)
    )
    
    private lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.layer.borderWidth = 1
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var itemImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkText
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 50))
        button.setImage(UIImage(systemName: "camera.circle")?.withConfiguration(config), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(presentPicker), for: .touchUpInside)
        return button
    }()
    
    private var itemImage: UIImage? = UIImage(systemName: "camera.circle")
    
    override func setupView() {
        super.setupView()
        setupUI()
    }
    
    private func setupUI() {
        nameTextField.customizeBorder(width: nil, color: nil)
        noteTextField.customizeBorder(width: nil, color: nil)

        self.anchorFill(view: mainView)
        
        mainView.anchor(view: itemImageButton) { kit in
            kit.leading(5)
            kit.centerY()
            kit.height(60)
            kit.width(60)
        }
        
        mainView.anchor(view: nameTextField) { kit in
            kit.leading(itemImageButton.trailingAnchor, 10)
            kit.top(10)
        }
        
        mainView.anchor(view: noteTextField) { kit in
            kit.leading(nameTextField)
            kit.bottom(10)
        }
    }
    
    @objc
    private func presentPicker() {}
    
    @objc
    private func didTapChangeName() {}
    
    @objc
    private func didTapAddNote() {}
    
}

extension MainView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            itemImage = imageSelected
            itemImageView.image = imageSelected
            itemImageButton.isHidden = true
            itemImageView.isHidden = false
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            itemImage = imageOriginal
            itemImageView.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

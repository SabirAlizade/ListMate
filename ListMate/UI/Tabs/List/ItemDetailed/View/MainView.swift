//
//  MainView.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func updateNameAndNote(name: String, note: String)
    func openImage(image: UIImage?)
    func openMenu()
}

final class MainView: BaseView {
    
    weak var delegate: MainViewDelegate?
    var itemImage: UIImage?
    
    var item: ItemModel? {
        didSet {
            configureCell()
        }
    }
    
    private let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .mainWhite
        return view
    }()
    
    private lazy var nameTextField = CustomTextField(
        placeHolder: "",
        font: .poppinsFont(size: 22, weight: .medium),
        border: .none,
        backgroundColor: .mainWhite,
        target: self,
        action: #selector(didTapValueChanged)
    )
    
    private lazy var noteTextField = CustomTextField(
        placeHolder: LanguageBase.detailed(.addNotePlaceHolder).translate,
        font: .poppinsFont(size: 18, weight: .light),
        border: .none,
        backgroundColor: .mainWhite,
        target: self,
        action: #selector(didTapValueChanged)
    )
    
    lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var itemImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkText
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(presentPicker), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Setup UI
    
    private func configureCell() {
        guard let item else { return }
        nameTextField.text = item.name
        noteTextField.text = item.notes
        loadImageData(imageName: item.imagePath)
    }
    
    override func setupView() {
        super.setupView()
        setupUI()
    }
    
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
            kit.trailing(mainView.trailingAnchor, 10)
        }
        
        mainView.anchor(view: noteTextField) { kit in
            kit.leading(nameTextField)
            kit.bottom(13)
            kit.trailing(mainView.trailingAnchor, 10)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapValueChanged() {
        guard let name = nameTextField.text, let note = noteTextField.text else { return }
        delegate?.updateNameAndNote(name: name, note: note)
    }
    
    @objc
    private func presentPicker() {
        delegate?.openImage(image: itemImage) ?? delegate?.openMenu()
    }
    
    // MARK: - Image Loading
    
    private func loadImageData(imageName: String?) {
        if let imageName = imageName, !imageName.isEmpty {
            if let cachedImage = ImageCacheManager.shared.getImage(forKey: imageName) {
                itemImageView.image = cachedImage
            }
        } else {
            setupDefaultImageButton()
        }
        itemImage = itemImageView.image
    }
    
    private func setupDefaultImageButton() {
        itemImageButton.setImage(UIImage(systemName: "photo.badge.plus"), for: .normal)
        itemImageButton.tintColor = .mainGreen
        itemImageButton.showsMenuAsPrimaryAction = true
        itemImageView.layer.borderWidth = 0
    }
}


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
    
    private var itemImage: UIImage?
    
    var item: ItemModel? {
        didSet {
            guard let item else { return }
            nameTextField.text = item.name
            noteTextField.text = item.notes
            loadImageData(imageName: item.image)
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
    
     lazy var itemImageButton: UIButton = {
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
    
    private func loadImageData(imageName: String?) {
        if imageName == nil {
            itemImageButton.setImage(UIImage(systemName: "photo.badge.plus"), for: .normal)
            itemImageButton.tintColor = .maingreen
            itemImageButton.showsMenuAsPrimaryAction = true
            itemImageView.layer.borderWidth = 0
        } else  {
            if let fileName = imageName {
                if let cachedImage = ImageCacheManager.shared.getImage(forKey: fileName) {
                    itemImageView.image = cachedImage
                } else {
                    let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
                    let fileURL = libraryDirectory.appendingPathComponent(fileName)
                    
                    if let image = UIImage(contentsOfFile: fileURL.path) {
                        itemImageView.image = image
                        ImageCacheManager.shared.setImage(image, forKey: fileName)
                    } else {
                        itemImageView.image = UIImage(named: "noImage")
                    }
                }
            }
            itemImage = itemImageView.image
        }
    }
    
    @objc
    private func presentPicker() {
        if itemImage != nil {
            delegate?.openImage(image: itemImage)
        } else {
            delegate?.openMenu()
        }
    }
    
    @objc
    private func didTapValueChanged() {
        guard let name = nameTextField.text else { return }
        guard let note = noteTextField.text else { return }
        delegate?.updateNameAndNote(name: name, note: note)
    }
}

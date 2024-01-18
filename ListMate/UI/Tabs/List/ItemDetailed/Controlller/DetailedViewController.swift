//
//  ItemDetailedViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import UIKit

class DetailedViewController: BaseViewController {
    
    private lazy var mainView: MainView = {
        let view = MainView()
        view.item = self.viewModel.item
        view.delegate = self
        return view
    }()
    
    private lazy var detailsView: DetailsView = {
        let view = DetailsView()
        view.item = self.viewModel.item
        view.delegate = self
        return view
    }()
    
    lazy var viewModel: DetailedViewModel = {
        let model = DetailedViewModel()
        return model
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        title = viewModel.item?.name
        closeBarButton()
        doneBarButton()
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    private func doneBarButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveChanges))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setupUI() {
        view.addSubview(menuButton)
        
        view.anchor(view: menuButton) { kit in
            kit.top(35, safe: true)
            kit.leading(20)
            kit.height(100)
        }

        view.anchor(view: mainView) { kit in
            kit.leading(20)
            kit.trailing(20)
            kit.top(35, safe: true)
            kit.height(100)
        }
        
        view.anchor(view: detailsView) { kit in
            kit.leading(20)
            kit.trailing(20)
            kit.top(mainView.bottomAnchor, 20)
        }
    }
    
    @objc
    private func saveChanges() {
        viewModel.reloadItemsData()
        dismiss(animated: true)
    }
    
    @objc
    private func openPreviewer(image: UIImage) {
        let vc = ImagePreviewViewController()
        vc.imageView.image = image
        vc.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        navigationController?.present(nc, animated: true)
    }
    
    //MARK: -
    private func configureMenu() {
        let button = UIButton()
        let menu = imagePickerButtons(takePictureAction: takePicture,
                                      presentPickerAction: presentPicker)
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true

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
        // delegate?.updateImage(image: selected)
     }
}

extension DetailedViewController: MainViewDelegate, DetailsViewDelegate, ImagePreviewDelegate {
    func updateImage(image: UIImage) {
        viewModel.updateImage(image: image)
        mainView.itemImageView.image = image
        dismiss(animated: true)
    }
    
    func openImage(image: UIImage?) {
    if image == nil {
        configureMenu()
    } else {
        guard let image else { return }
        openPreviewer(image: image)
    }
    }
    
    func updateDetailsData(measeure: Measures, price: Double, store: String) {
        viewModel.updateValues(measeure: measeure, price: price, store: store)
    }
    
    func updateNameAndNote(name: String, note: String) {
        viewModel.updateValues(name: name, note: note)
    }
}


extension DetailedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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


//MARK: - PICKER SET UP
/*
 @objc
 private func presentPicker() {
 let picker = UIImagePickerController()
 picker.sourceType = .photoLibrary
 picker.allowsEditing = true
 picker.delegate = self
 self.present(picker, animated: true, completion: nil)
 }
 
 @objc
 private func didTapAdd() {
 guard let name = nameTextField.text else { return }
 guard let price = Double(pricetextFiled.text ?? "1") else { return }
 guard let image = itemImage else { return }
 
 UserDefaults.standard.saveImage(image: image, key: name)
 viewModel.saveItem(name: name,
 price: price,
 image: name,
 measure: itemAmount.item ?? .pcs)
 dismiss(animated: true)
 }
 */

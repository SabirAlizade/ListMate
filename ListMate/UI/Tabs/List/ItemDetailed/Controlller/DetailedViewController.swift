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
    
    override func setupUIComponents() {
        super.setupUIComponents()
        title = viewModel.item?.name
        closeBarButton()
        doneBarButton()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
        configureMenu()
    }
    
    private func doneBarButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveChanges))
        doneButton.tintColor = .maingreen
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setupUI() {
        
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
    
    private func configureMenu() {
        let menu = imagePickerButtons(takePictureAction: takePicture,
                                      presentPickerAction: presentPicker)
        mainView.itemImageButton.menu = menu
    }
    
    private func savePicture() {
        guard let selected = mainView.itemImageView.image else { return }
        viewModel.updateImage(image: selected)
    }
    
    @objc
    private func saveChanges() {
        viewModel.reloadItemsData()
        savePicture()
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
}

extension DetailedViewController: MainViewDelegate, DetailsViewDelegate, ImagePreviewDelegate {
    func updateImage(image: UIImage) {
        viewModel.updateImage(image: image)
        mainView.itemImageView.image = image
        dismiss(animated: true)
    }
    
    func openImage(image: UIImage?) {
        guard let image else { return }
        openPreviewer(image: image)
    }
    
    func openMenu() {
        configureMenu()
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
            mainView.itemImageView.image = imageSelected
            mainView.itemImageButton.isHidden = true
            mainView.itemImageView.layer.borderWidth = 1
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainView.itemImageView.image = imageOriginal
        }
        picker.dismiss(animated: true)
    }
}

//
//  ItemDetailedViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import UIKit
import RealmSwift

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
    
    private lazy var activityIndicator: ActivityIndicator = {
        return ActivityIndicator.shared
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
    
    @objc
    private func saveChanges() {
        viewModel.reloadItemsData()
        saveSelectedPicture()
        dismiss(animated: true)
    }
    //MARK: - IMAGE PICKER HANDLING
    private func configureMenu() {
        let menu = imagePickerButtons(takePictureAction: takePicture,
                                      presentPickerAction: presentPicker)
        mainView.itemImageButton.menu = menu
    }
    
    private func saveSelectedPicture() {
        guard let selected = mainView.itemImageView.image else { return }
        viewModel.updateImage(image: selected)
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
    override func takePicture() {
        presentImagePicker(sourceType: .camera)
    }
    
    @objc
    private func presentPicker() {
        presentImagePicker(sourceType: .photoLibrary)
        activityIndicator.showActivityIndicator(view: self.view)
    }
}

extension DetailedViewController: MainViewDelegate, DetailsViewDelegate, ImagePreviewDelegate {
    func updateImage(image: UIImage) {
        DispatchQueue.main.async {
            self.mainView.itemImageView.image = image
            self.mainView.itemImage = image
            self.dismiss(animated: true)
        }
    }
    
    func openImage(image: UIImage?) {
        guard let image else { return }
        openPreviewer(image: image)
    }
    
    func openMenu() {
        configureMenu()
    }
    
    func updateDetailsData(measeure: Measures, price: Decimal128, store: String) {
        viewModel.updateValues(measeure: measeure, price: price, store: store)
    }
    
    func updateNameAndNote(name: String, note: String) {
        viewModel.updateValues(name: name, note: note)
    }
}

extension DetailedViewController: ImagePickerDelegate {
    func didSelectImage(_ image: UIImage, isEdited: Bool) {
        if isEdited {
            mainView.itemImageButton.isHidden = true
            mainView.itemImageView.layer.borderWidth = 1
        }
        mainView.itemImageView.image = image
    }
}

//
//  ItemDetailedViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import UIKit
import RealmSwift

class DetailedViewController: BaseViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        return UIView()
    }()
    
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
        return DetailedViewModel()
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let translatedTitle = LanguageBase.system(.doneKeyboardButton).translate
        let button = UIBarButtonItem(
            title: translatedTitle,
            style: .plain,
            target: self,
            action: #selector(saveChanges)
        )
        button.tintColor = .mainGreen
        return button
    }()
    
    private lazy var activityIndicator: ActivityIndicator = {
        return ActivityIndicator.shared
    }()
    
    // MARK: - Setup UI
    
    override func setupUIComponents() {
        super.setupUIComponents()
        title = viewModel.item?.name
        configureDoneButton()
        closeBarButton()
        registerForKeyboardNotifications()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
        configureMenu()
    }
    
    private func configureDoneButton() {
        doneButton.tintColor = .maingreen
        navigationItem.rightBarButtonItem = doneButton
    }

    private func setupUI() {
        view.anchor(view: scrollView) { kit in
            kit.top(view.topAnchor)
            kit.leading(view.leadingAnchor)
            kit.trailing(view.trailingAnchor)
            kit.bottom(view.bottomAnchor)
        }
        
        scrollView.anchor(view: contentView) { kit in
            kit.top(scrollView.topAnchor)
            kit.leading(scrollView.leadingAnchor)
            kit.trailing(scrollView.trailingAnchor)
            kit.bottom(scrollView.bottomAnchor)
            kit.width(scrollView.widthAnchor)
        }
        
        contentView.anchor(view: mainView) { kit in
            kit.top(contentView.topAnchor, 35)
            kit.leading(contentView.leadingAnchor, 20)
            kit.trailing(contentView.trailingAnchor, 20)
            kit.height(100)
        }
        
        contentView.anchor(view: detailsView) { kit in
            kit.top(mainView.bottomAnchor, 20)
            kit.leading(contentView.leadingAnchor, 20)
            kit.trailing(contentView.trailingAnchor, 20)
            kit.bottom(contentView.bottomAnchor)
        }
    }
    
    private func configureDoneButton() {
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Actions
    
    @objc
    private func saveChanges() {
        viewModel.updateValues()
        viewModel.reloadItemsData()
        saveSelectedPicture()
        dismiss(animated: true)
    }
    
    // MARK: - Image Picker Handling
    
    private func configureMenu() {
        let menu = imagePickerButtons(
            takePictureAction: takePicture,
            presentPickerAction: presentPicker
        )
        mainView.itemImageButton.menu = menu
    }
    
    private func saveSelectedPicture() {
        guard let selectedImage = mainView.itemImageView.image else { return }
        viewModel.updateImage(image: selectedImage)
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
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
    
    func updateDetailsData(measure: Measures, price: Decimal128, store: String) {
        viewModel.updateValues(measure: measure, price: price, store: store)
    }
    
    func updateNameAndNote(name: String, note: String) {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertMessage(
                title: LanguageBase.newItem(.emptyNameAlarmTitle).translate,
                message: LanguageBase.newItem(.emptyNameAlarmBody).translate
            )
            doneButton.isEnabled = false
        } else {
            viewModel.newItem = name
            viewModel.newNote = note
            doneButton.isEnabled = true
        }
    }
    
    func openMenu() {
        configureMenu()
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

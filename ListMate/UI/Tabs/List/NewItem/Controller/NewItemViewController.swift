//
//  NewItemViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

class NewItemViewController: BaseViewController {
    
    private var bottomCostant: NSLayoutConstraint?
    
    private var itemImage: UIImage?
    
    lazy var viewModel: NewItemViewModel = {
        let model = NewItemViewModel(session: .shared)
        model.suggestionDelegate = self
        return model
    }()
    
    private lazy var measuresControl: UISegmentedControl = {
        let control = UISegmentedControl(items: viewModel.measuresArray)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var itemAmount: ItemAmountView = {
        let view = ItemAmountView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var suggestionToolbar: SuggestionsToolbarView = {
        let toolbar = SuggestionsToolbarView(viewModel: viewModel)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.isHidden = true
        toolbar.viewModel.suggestionDelegate = self
        return toolbar
    }()
    
    private lazy var nameTextField = CustomTextField(placeHolder: "Enter name of item",
                                                     delegate: self,
                                                     target: self,
                                                     action:  #selector(textFieldDidChange(_:)))
    
    private let priceLabel = CustomLabel(text: "Price per package:",
                                         textColor: .black,
                                         font: .poppinsFont(size: 12, weight: .light),
                                         alignment: .center)
    
    private let quantityLabel = CustomLabel(text: "Quantity:",
                                            textColor: .black,
                                            font: .poppinsFont(size: 12, weight: .light),
                                            alignment: .left)
    
    private lazy var priceTextField = PriceTextField(placeHolder: "Price")
    
    private lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.layer.borderWidth = 0
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var itemImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .maingreen
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 50))
        button.setImage(UIImage(systemName: "photo.badge.plus")?.withConfiguration(config), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.showsMenuAsPrimaryAction = true
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton = CustomButton(title: "Add",
                                               backgroundColor: .maingreen,
                                               titleColor: .white,
                                               target: self,
                                               action: #selector(didTapAdd))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomCostant = suggestionToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomCostant?.isActive = true
        configureKeyboardNotification()
    }
    
    private func configureAutoresizing() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        nameTextField.becomeFirstResponder()
        view.backgroundColor = .maingray
        closeBarButton()
        configureMenu()
        configureAutoresizing()
        configureMeasuresControl()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    private func configureMenu() {
        let menu = imagePickerButtons(takePictureAction: takePicture,
                                      presentPickerAction: presentPicker)
        itemImageButton.menu = menu
    }
    
    private func setupUI() {
        view.addSubview(nameTextField)
        view.addSubview(measuresControl)
        view.addSubview(priceLabel)
        view.addSubview(priceTextField)
        view.addSubview(quantityLabel)
        view.addSubview(itemAmount)
        view.addSubview(itemImageView)
        view.addSubview(itemImageButton)
        view.addSubview(saveButton)
        view.addSubview(suggestionToolbar)
        
        NSLayoutConstraint.activate([
            
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            measuresControl.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            measuresControl.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            measuresControl.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            measuresControl.heightAnchor.constraint(equalToConstant: 40),
            
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            priceLabel.widthAnchor.constraint(equalToConstant: 140),
            priceLabel.heightAnchor.constraint(equalToConstant: 44),
            priceLabel.topAnchor.constraint(equalTo: measuresControl.bottomAnchor, constant: 10),
            
            quantityLabel.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -160),
            quantityLabel.widthAnchor.constraint(equalToConstant: 140),
            quantityLabel.heightAnchor.constraint(equalToConstant: 44),
            quantityLabel.topAnchor.constraint(equalTo: measuresControl.bottomAnchor, constant: 10),
            
            priceTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            priceTextField.widthAnchor.constraint(equalToConstant: 120),
            priceTextField.heightAnchor.constraint(equalToConstant: 44),
            priceTextField.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: -3),
            
            itemAmount.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -20),
            itemAmount.widthAnchor.constraint(equalToConstant: 140),
            itemAmount.heightAnchor.constraint(equalToConstant: 44),
            itemAmount.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: -3),
            
            itemImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemImageView.topAnchor.constraint(equalTo: itemAmount.bottomAnchor, constant: 6),
            itemImageView.heightAnchor.constraint(equalToConstant: 90),
            itemImageView.widthAnchor.constraint(equalToConstant: 90),
            
            itemImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemImageButton.topAnchor.constraint(equalTo: itemAmount.bottomAnchor, constant: 6),
            itemImageButton.heightAnchor.constraint(equalToConstant: 90),
            itemImageButton.widthAnchor.constraint(equalToConstant: 90),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 15),
            saveButton.widthAnchor.constraint(equalToConstant: 160),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            suggestionToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            suggestionToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            suggestionToolbar.heightAnchor.constraint(equalToConstant: 40),
            suggestionToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func configureMeasuresControl() {
        measuresControl.selectedSegmentIndex = Measures.allCases.firstIndex(of: viewModel.selectedMeasure) ?? 0
        measuresControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc//TODO: TRY TO REMOVE SENDER AND USE UISEGMENT CONTROL INSTEAD
    private func segmentControlValueChanged(_ sender: UISegmentedControl) {
        let selectedMeasure = Measures.allCases[sender.selectedSegmentIndex]
        viewModel.selectedMeasure = selectedMeasure
        itemAmount.itemMeasure = selectedMeasure
    }
    
    @objc
    private func didTapAdd() {
        guard let name = nameTextField.text else { return }
        if name.isEmpty {
            alertMessage(title: "Empty name", message: "Please enter name of item")
        } else {
            let pricetext = priceTextField.text?.isEmpty ?? true ? "0" : priceTextField.text
            guard let price = Double(pricetext ?? "0") else { return }
            ImageManager.shared.saveImageToLibrary(image: itemImage) { imagePath in
                self.viewModel.saveItem(name: name,
                                        price: price,
                                        imagePath: imagePath,
                                        measure: self.itemAmount.itemMeasure ?? .pcs)
                self.dismiss(animated: true)
            }
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
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard nameTextField.isEditing else {
            suggestionToolbar.isHidden = true
            return
        }
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.bottomCostant!, keyboardWillShow: true)
        catalogCountCheck()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.bottomCostant!, keyboardWillShow: false)
        suggestionToolbar.isHidden = true
    }
    
    private func catalogCountCheck() {
        suggestionToolbar.isHidden = viewModel.catalogItems.isEmpty
    }
    
    func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        if keyboardWillShow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0)
            let bottomConstant: CGFloat = 20
            self.bottomCostant?.constant = -keyboardHeight - (safeAreaExists ? 0 : bottomConstant)
        } else {
            viewBottomConstraint.constant = 20
        }
        
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let newText = textField.text else { return }
        viewModel.filterSuggestions(name: newText)
    }
}

extension NewItemViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            itemImage = imageSelected
            itemImageView.image = imageSelected
            itemImageButton.isHidden = true
            itemImageView.isHidden = false
            itemImageView.layer.borderWidth = 1
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            itemImage = imageOriginal
            itemImageView.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewItemViewController: ItemAmountDelegate {
    func setAmount(amount: Double) {
        viewModel.setAmount(amount: amount)
    }
}

extension NewItemViewController: PassSuggestionDelegate {
    func manageToolBar() {
        catalogCountCheck()
    }
    
    func updateSuggestionsData() {
        suggestionToolbar.collectionView.reloadData()
    }
    
    func passSuggested(name: String, price: Double, measure: Measures) {
        self.nameTextField.text = name
        self.priceTextField.text = "\(price)"
        self.measuresControl.selectedSegmentIndex = Measures.allCases.firstIndex(of: measure) ?? 0
    }
}

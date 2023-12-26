//
//  NewItemViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

class NewItemViewController: BaseViewController {
    
    private var itemImage: UIImage? = UIImage(systemName: "camera.circle") //MARK: TO VM?
    
    lazy var viewModel: NewItemViewModel = {
        let model = NewItemViewModel(session: .shared)
        return model
    }()
    
    private let nameTextField = CustomTextField(placeHolder: "Enter name of item")
    
    private lazy var measuresControl: UISegmentedControl = {
        let control = UISegmentedControl(items: viewModel.measuresArray)
        return control
    }()
    
    private lazy var itemAmount: ItemAmountView = {
        let view = ItemAmountView()
        view.delegate = self
        return view
    }()
    
    private let priceLabel = CustomLabel(text: "Price per package:", textColor: .black, font: .poppinsFont(size: 12, weight: .light), alignment: .center)
    
    private let quantityLabel = CustomLabel(text: "Quantity:", textColor: .black, font: .poppinsFont(size: 12, weight: .light), alignment: .center)
    
    private lazy var pricetextFiled = CustomTextField(placeHolder: "Enter price", keybord: .numberPad, dataSource: .none)
    
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
    
    private lazy var saveButton = CustomButton(title: "Add",
                                               backgroundColor: .maingreen,
                                               titleColor: .white,
                                               target: self,
                                               action: #selector(didTapAdd))
    
    override func setupUIComponents() {
        super.setupUIComponents()
        view.backgroundColor = .maingray
        closeBarButton()
        configureMeasuresControl()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    private func setupUI() {
        
        let labelHStack = UIView().HStack(views: priceLabel, quantityLabel, spacing: 60, distribution: .equalSpacing)
        
        let hStack = UIView().HStack(views: pricetextFiled.withHeight(44), itemAmount, spacing: 60, distribution: .equalSpacing)
        let vStack = UIView().VStack(views: nameTextField.withHeight(44), measuresControl.withHeight(44), labelHStack, hStack, spacing: 20, distribution: .fill)
        
        view.anchor(view: vStack) { kit in
            kit.leading(20)
            kit.trailing(20)
            kit.top(10, safe: true)
        }
        
        view.anchor(view: itemImageView) { kit in
            kit.centerX()
            kit.top(vStack.bottomAnchor, 15)
            kit.width(90)
            kit.height(90)
        }
        
        view.anchor(view: itemImageButton) { kit in
            kit.centerX()
            kit.top(vStack.bottomAnchor, 15)
            kit.width(90)
            kit.height(90)
        }
        
        view.anchor(view: saveButton) { kit in
            kit.centerX()
            kit.bottom(15,safe: true)
            kit.width(160)
        }
    }
    
    private func configureMeasuresControl() {
        measuresControl.selectedSegmentIndex = Measures.allCases.firstIndex(of: viewModel.selectedMeasure) ?? 0
        measuresControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc
    private func segmentControlValueChanged(_ sender: UISegmentedControl) {
        let selectedMeasure = Measures.allCases[sender.selectedSegmentIndex]
        viewModel.selectedMeasure = selectedMeasure
        itemAmount.itemMeasure = selectedMeasure
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
                           measure: itemAmount.itemMeasure ?? .pcs)
        dismiss(animated: true)
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

extension NewItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
extension UserDefaults {
    func saveImage(image: UIImage, key: String) {
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        saveImageData(imageData: data, key: key)
    }
    
    private func saveImageData(imageData: Data, key: String) {
        setValue(imageData, forKey: key)
    }
    
    private func readData(key: String) -> Data? {
        return data(forKey: key)
    }
    
    func readImage(key: String) -> UIImage? {
        guard let imageData = readData(key: key) else { return UIImage() }
        return UIImage(data: imageData)
    }
}

extension NewItemViewController: ItemAmountDelegate {
    func setAmount(amount: Double) {
        viewModel.setAmount(amount: amount)
    }
}

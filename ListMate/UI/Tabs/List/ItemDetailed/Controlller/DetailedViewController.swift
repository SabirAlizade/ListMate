//
//  ItemDetailedViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import UIKit

class DetailedViewController: BaseViewController {
    
    var mainView: MainView = {
       let view = MainView()
        return view
    }()
    
    
    
    override func setupUIComponents() {
        super.setupUIComponents()
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    private func setupUI() {
        view.anchor(view: mainView) { kit in
            kit.leading(20)
            kit.trailing(20)
            kit.top(35, safe: true)
            kit.height(100)
        }
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
//        guard let name = nameTextField.text else { return }
//        guard let price = Double(pricetextFiled.text ?? "1") else { return }
     guard let image = itemImage else { return }
     
//        UserDefaults.standard.saveImage(image: image, key: name)
//        viewModel.saveItem(name: name,
//                           price: price,
//                           image: name,
//                           measure: itemAmount.item ?? .pcs)
     dismiss(animated: true)
 }
 */

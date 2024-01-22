//
//  NewListViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

class NewListViewController: BaseViewController {
    
    lazy var viewModel: NewListViewModel = {
        let model = NewListViewModel(session: .shared)
        return model
    }()
    
    private let nameTextField = CustomTextField(placeHolder: "New list")
    
    private lazy var saveButton = CustomButton(title: "Save",
                                               backgroundColor: .buttongreen,
                                               titleColor: .white,
                                               target: self,
                                               action: #selector(didTapSave))
    
    override func setupUIComponents() {
        super.setupUIComponents()
        closeBarButton()
        title = "Add list"
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
        nameTextField.becomeFirstResponder()
    }
    
    private func setupUI() {
        let vStack = UIView().VStack(views: nameTextField.withHeight(44),
                                     saveButton.withHeight(44), spacing: 15, distribution: .fill)
        
        view.anchor(view: vStack) { kit in
            kit.top(25, safe: true)
            kit.leading(60)
            kit.trailing(60)
        }
    }
    
    @objc
    private func didTapSave() {
        guard let name = nameTextField.text else { return }
        if name.isEmpty {
            alertMessage(title: "Empty name", message: "Please enter name of list")
        } else {
            viewModel.saveListItem(name: name)
            dismiss(animated: true)
        }
    }
}

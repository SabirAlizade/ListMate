//
//  NewListViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

class NewListViewController: BaseViewController {
    
    private lazy var viewModel: NewListViewModel = {
        let model = NewListViewModel()
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
        view.backgroundColor = .white
        closeBarButton()
        setupLargeTitle(title: "Add List", isLargeTitle: false)
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
        setupUI()
    }
    
    private func setupUI() {
        let vStack = UIView().VStack(views: nameTextField.withHeight(44), saveButton.withHeight(44), spacing: 15, distribution: .fill)
        
        view.anchor(view: vStack) { kit in
            kit.top(25, safe: true)
            kit.leading(60)
            kit.trailing(60)
        }
    }
    
    @objc
    private func didTapSave() {
        guard let name = nameTextField.text else { return }
        viewModel.saveListItem(name: name)
        dismiss(animated: true)
    }
}

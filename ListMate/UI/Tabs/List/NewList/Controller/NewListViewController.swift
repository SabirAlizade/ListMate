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
    
    private let nameTextField = CustomTextField(placeHolder: LanguageBase.list(.newListPlaceholder).translate)
    
    private lazy var saveButton = CustomButton(title: LanguageBase.list(.saveButton).translate,
                                               backgroundColor: .buttongreen,
                                               titleColor: .white,
                                               target: self,
                                               action: #selector(didTapSave))
    
    override func setupUIComponents() {
        super.setupUIComponents()
        closeBarButton()
        title = LanguageBase.list(.newListTitle).translate
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
            alertMessage(title: LanguageBase.list(.emptyNameAlarmTitle).translate,
                         message: LanguageBase.list(.emptyNameAlarmBody).translate)
        } else {
            viewModel.saveListItem(name: name)
            dismiss(animated: true)
        }
    }
}

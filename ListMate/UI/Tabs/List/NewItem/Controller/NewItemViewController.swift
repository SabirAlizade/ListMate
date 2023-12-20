//
//  NewItemViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

class NewItemViewController: BaseViewController {
    
    private lazy var viewModel: NewItemVewModel = {
        let model = NewItemVewModel()
        return model
    }()
    
    private let nameTextField = CustomTextField(placeHolder: "Enter name of item")
    
    private lazy var measuresControl: UISegmentedControl = {
        let control = UISegmentedControl(items: viewModel.measuresArray)
        return control
    }()
    
    private lazy var itemAmount: ItemAmountView = {
        let view = ItemAmountView()
        return view
    }()
    
    private lazy var pricetextFiled = CustomTextField(placeHolder: "Enter price")
    
    //TODO: ADD IMAGE UPLOADER HERE
    
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
        let hStack = UIView().HStack(views: itemAmount.withHeight(44), pricetextFiled, spacing: 5, distribution: .fill)
        let vStack = UIView().VStack(views: nameTextField, measuresControl.withHeight(44), hStack, saveButton, spacing: 10, distribution: .fill)
         
        view.anchor(view: vStack) { kit in
            kit.leading(16)
            kit.trailing(16)
            kit.top(10, safe: true)
            kit.bottom(15, safe: true)
        }
    }
    
    private func configureMeasuresControl() {
        measuresControl.selectedSegmentIndex = Measures.allCases.firstIndex(of: viewModel.selectedMeasure) ?? 0
        measuresControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc
    private func segmentControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.selectedMeasure = Measures.allCases[sender.selectedSegmentIndex]
    }
    
    @objc
    private func didTapAdd() {
        
    }
}

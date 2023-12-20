//
//  ItemAmountView.swift
//  ListMate
//
//  Created by Sabir Alizade on 20.12.23.
//

import UIKit

class ItemAmountView: BaseView {
    
    private lazy var stepperView: UIStackView = {
        let view = UIStackView()
        view.withBorder(width: 1, color: .maingreen)
        view.layer.cornerRadius = 16
        view.backgroundColor = .lightgreen
        return view
    }()
    
    private lazy var amountTextField = CustomTextField(placeHolder: "Enter amount")
    //TODO: ADD MEASURE LABEL TO THE RIGHT
    
    private lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightgreen
        button.setTitle( "-", for: .normal)
        button.setTitleColor(.maingreen, for: .normal)
        button.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .maingreen
        button.setTitle( "+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        return button
    }()
    
    override func setupView() {
        super.setupView()
        setupUI()
    }
    
    private func setupUI() {
        
        self.anchorFill(view: stepperView)
        
        let hStack = UIView().HStack(views: minusButton, amountTextField, plusButton, spacing: 9, distribution: .fill )
        
        stepperView.anchor(view: hStack) { kit in
            kit.leading()
            kit.trailing()
            kit.top()
            kit.bottom()
        }
    }

    
    @objc
    private func didTapMinus() {
        
    } 
    
    @objc
    private func didTapPlus() {
        
    }
}


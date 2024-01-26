//
//  ItemAmountView.swift
//  ListMate
//
//  Created by Sabir Alizade on 20.12.23.
//

import UIKit

protocol ItemAmountDelegate: AnyObject {
    func setAmount(amount: Double)
}

class ItemAmountView: BaseView {
    
    weak var delegate: ItemAmountDelegate?
    
    var quantityAmount: Double = 1
    private var minValue: Double = 1
    
    var itemMeasure: Measures? {
        didSet {
            guard let item = itemMeasure else { return }
            switch item {
            case .pcs:
                quantityAmount = 1
                minValue = 1
            case .kgs, .l:
                quantityAmount = 1
                minValue = 0.1
            }
            checkMinimumValue()
            amountTextField.text = Double.doubleToString(double: quantityAmount)
        }
    }
    
    var item: ItemModel? {
        didSet {
            guard let item else { return }
            itemMeasure = item.measure
            quantityAmount = item.amount
            amountTextField.text = Double.doubleToString(double: quantityAmount)
            checkMinimumValue()
        }
    }
    
    private lazy var stepperView: UIStackView = {
        let view = UIStackView()
        view.withBorder(width: 1, color: .maingreen)
        view.layer.cornerRadius = 16
        view.backgroundColor = .lightgreen
        return view
    }()
    
    lazy var amountTextField : UITextField = {
        let textField = UITextField()
        textField.text = "1"
        textField.textColor = .black
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.font = .poppinsFont(size: 22, weight: .regular)
        textField.doneAccessory = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    
    private lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.tintColor = .maingreen
        button.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .maingreen
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        return button
    }()
    
    override func setupView() {
        super.setupView()
        setupUI()
        checkMinimumValue()
    }
    
    private func setupUI() {
        self.anchor(view: stepperView) { kit in
            kit.leading()
            kit.trailing()
            kit.top()
            kit.bottom()
            kit.width(170)
            kit.height(40)
            
            let hStack = UIView().HStack(views: minusButton.withWidth(45),
                                         amountTextField.withWidth(90),
                                         plusButton.withWidth(45),
                                         spacing: 5,
                                         distribution: .fill)
            
            stepperView.anchor(view: hStack) { kit in
                kit.leading()
                kit.trailing()
                kit.top(1)
                kit.bottom(1)
            }
        }
    }
    
    private func checkMinimumValue() {
        if quantityAmount <= minValue {
            minusButton.isEnabled = false
            minusButton.tintColor = .maingreen.withAlphaComponent(0.5)
        } else {
            minusButton.isEnabled = true
            minusButton.tintColor = .maingreen
        }
    }
    
    @objc
    private func didTapMinus() {
        updateAmount(with: itemMeasure ?? .pcs, increment: false)
        amountTextField.text = Double.doubleToString(double: quantityAmount)
        delegate?.setAmount(amount: quantityAmount)
    }

    private func updateAmount(with measureType: Measures, increment: Bool) {
        switch measureType {
        case .pcs:
            quantityAmount = max(quantityAmount + (increment ? 1 : -1), 1)
        case .kgs, .l:
            let step: Double = 0.5
            
            if increment {
                    quantityAmount = (quantityAmount == 0.1) ? step : quantityAmount + step
                } else {
                    quantityAmount = (quantityAmount == 0.5) ? 0.1 : quantityAmount - step
                }
            }
        checkMinimumValue()
    }

    @objc
    private func didTapPlus() {
        updateAmount(with: itemMeasure ?? .pcs, increment: true)
        amountTextField.text = Double.doubleToString(double: quantityAmount)
        delegate?.setAmount(amount: quantityAmount)
    }
    
    @objc
    private func textFieldDidChange() {
        guard let amount = Double(amountTextField.text ?? "") else { return }
        delegate?.setAmount(amount: amount)
    }
}



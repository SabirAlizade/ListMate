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
    private func didTapMinus() { //MARK:  ALLERGY ON 2
        checkMinimumValue()
        decrement(measureType: itemMeasure ?? .pcs)
        amountTextField.text = Double.doubleToString(double: quantityAmount)
        delegate?.setAmount(amount: quantityAmount)
    }
    
    private func decrement(measureType: Measures) {
        switch measureType {
        case .pcs:
            if quantityAmount > minValue {
                quantityAmount -= 1
            }
        case .kgs, .l:
                if quantityAmount > 0.5 {
                    quantityAmount -= 0.5
                    return
                }
                if quantityAmount <= 0.5 {
                    quantityAmount = 0.1
                    checkMinimumValue()
                }
            }
        }
    
    private func increment(measureType: Measures) {
        switch measureType {
        case .pcs:
            quantityAmount += 1
        case .kgs, .l:
            if quantityAmount == 0.1 {
                quantityAmount = 0.5
            } else {
                quantityAmount += 0.5
            }
        }
    }
    
    @objc
    private func textFieldDidChange() {
        guard let amount = Double(amountTextField.text ?? "") else { return }
        delegate?.setAmount(amount: amount)
    }
    
    @objc
    private func didTapPlus() {
        checkMinimumValue()
        increment(measureType: itemMeasure ?? .pcs)
        amountTextField.text = Double.doubleToString(double: quantityAmount)
        delegate?.setAmount(amount: quantityAmount)
    }
}



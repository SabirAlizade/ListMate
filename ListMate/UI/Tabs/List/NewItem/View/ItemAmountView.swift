//
//  ItemAmountView.swift
//  ListMate
//
//  Created by Sabir Alizade on 20.12.23.
//

import UIKit
import RealmSwift

protocol ItemAmountDelegate: AnyObject {
    func setAmount(amount: Decimal128)
}

class ItemAmountView: BaseView {
    
    weak var delegate: ItemAmountDelegate?
    var quantityAmount: Decimal128 = 1
    private var minValue: Decimal128 = 1
    
    var itemMeasure: Measures? {
        didSet {
            configureMeasure()
        }
    }
    
    var item: ItemModel? {
        didSet {
            configureCell()
        }
    }
    
    private lazy var stepperView: UIStackView = {
        let view = UIStackView()
        view.withBorder(width: 1, color: .mainGreen)
        view.layer.cornerRadius = 8
        view.backgroundColor = .lightGreen
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
        button.tintColor = .mainGreen
        button.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .mainGreen
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Setup UI
    
    private func configureCell() {
        guard let item else { return }
        itemMeasure = item.measure
        quantityAmount = item.amount
        amountTextField.text = Double.doubleToString(double: quantityAmount.doubleValue)
        checkMinimumValue()
    }
    
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
            
            let hStack = UIView().HStack(
                views: minusButton.withWidth(45),
                amountTextField.withWidth(90),
                plusButton.withWidth(45),
                spacing: 5,
                distribution: .fill
            )
            
            stepperView.anchor(view: hStack) { kit in
                kit.leading()
                kit.trailing()
                kit.top(1)
                kit.bottom(1)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapMinus() {
        updateAmount(increment: false)
        amountTextField.text = Double.doubleToString(double: quantityAmount.doubleValue)
        delegate?.setAmount(amount: quantityAmount)
    }
    
    @objc
    private func didTapPlus() {
        updateAmount(increment: true)
        amountTextField.text = Double.doubleToString(double: quantityAmount.doubleValue)
        delegate?.setAmount(amount: quantityAmount)
    }
    
    @objc
    private func textFieldDidChange() {
        guard let amount = Decimal128.fromStringToDecimal(string: amountTextField.text ?? "") else { return }
        delegate?.setAmount(amount: amount)
        checkMinimumValue()
    }
    
    // MARK: - Amount Operations
    
    private func configureMeasure() {
        guard let measure = itemMeasure else { return }
        switch measure {
        case .pcs:
            quantityAmount = 1
            minValue = 1
        case .kgs, .l:
            quantityAmount = 1
            minValue = 0.1
        }
        checkMinimumValue()
        amountTextField.text = Double.doubleToString(double: quantityAmount.doubleValue)
    }
    
    private func checkMinimumValue() {
        if quantityAmount <= minValue {
            minusButton.isEnabled = false
            minusButton.tintColor = .mainGreen.withAlphaComponent(0.5)
        } else {
            minusButton.isEnabled = true
            minusButton.tintColor = .mainGreen
        }
    }
    
    private func updateAmount(increment: Bool) {
        guard let measureType = itemMeasure else { return }
        switch measureType {
        case .pcs:
            quantityAmount = max(quantityAmount + (increment ? 1 : -1), 1)
        case .kgs, .l:
            let step: Decimal128 = 0.5
            
            if increment {
                quantityAmount = (quantityAmount == 0.1) ? step : quantityAmount + step
            } else {
                quantityAmount = (quantityAmount == 0.5) ? 0.1 : quantityAmount - step
            }
        }
        checkMinimumValue()
    }
}



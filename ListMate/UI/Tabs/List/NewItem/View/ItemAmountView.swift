//
//  ItemAmountView.swift
//  ListMate
//
//  Created by Sabir Alizade on 20.12.23.
//

import UIKit

class ItemAmountView: BaseView {
    
    var currentAmount: Double = 1
    var step: Double = 1
    let minPcsValue: Double = 1
    let minkgValue: Double = 0.1
    
    var item: Measures? {
        didSet {
            guard let item = item else { return }
            switch item {
            case .pcs:
                step = 1
                currentAmount = 1
                amountTextField.text = String(format: "%.0f", currentAmount)
                checkMinimumValue(minValue: 1.0)
          
            case .kgs, .l:
                step = 0.5
                currentAmount = 1
                amountTextField.text = "\(currentAmount)"
                checkMinimumValue(minValue: 0.1)
            }
        }
    }
    
    
    private lazy var stepperView: UIStackView = {
        let view = UIStackView()
        view.withBorder(width: 1, color: .maingreen)
        view.layer.cornerRadius = 16
        view.backgroundColor = .lightgreen
        return view
    }()
    
    private let amountTextField : UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.text = "1"
        textField.font = .poppinsFont(size: 30, weight: .regular)
        return textField
    }()
    
    //TODO: ADD MEASURE LABEL TO THE RIGHT?
    //TODO: TEXTFIELD HAS TO HAVE LEFT AND RIGHT BUTTON
    
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
        checkMinimumValue(minValue: 1.0)
    }
    
    private func setupUI() {
        
        self.anchor(view: stepperView) { kit in
            kit.leading()
            kit.trailing()
            kit.top()
            kit.bottom()
            kit.width(170)
            kit.height(40)
            
            let hStack = UIView().HStack(views: minusButton.withWidth(45), amountTextField.withWidth(70), plusButton.withWidth(45), spacing: 5, distribution: .fill )
            
            stepperView.anchor(view: hStack) { kit in
                kit.leading()
                kit.trailing()
                kit.top(1)
                kit.bottom(1)
            }
        }
    }
    
    private func changeValue(step: Double) {
        
    }
    
    
    func checkMinimumValue(minValue: Double) {
        if currentAmount == minValue {
            minusButton.isEnabled = false
            minusButton.tintColor = .maingreen.withAlphaComponent(0.5)
        }
    }
    
    @objc
    private func didTapMinus() {
        currentAmount -= step
        amountTextField.text = "\(currentAmount)"
        if item == .pcs {
            amountTextField.text = String(format: "%.0f", currentAmount)
        }
    }
    
    @objc
    private func didTapPlus() {
        currentAmount += step
        amountTextField.text = "\(currentAmount)"
        if item == .pcs {
            amountTextField.text = String(format: "%.0f", currentAmount)
        }
 
    }
}



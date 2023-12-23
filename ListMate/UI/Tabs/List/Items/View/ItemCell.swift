//
//  ItemCelll.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

//protocol ItemCellDelegate: AnyObject {
//   // func didTapPlusButton(in cell: ItemCell)
//   // func didTapMinusButton(in cell: ItemCell)
//    func didUpdateText(in cell: ItemCell, newText: String)
//}

class ItemCell: BaseCell {
//    weak var delegate: ItemCellDelegate?
    
    var item: ItemModel? {
        didSet {
            guard let item = item else { return }
            nameLabel.text = item.name
            priceLabel.text = "\(item.price) $"
            if let image = UserDefaults.standard.readImage(key: item.image) {
                itemImageView.image = image
            }
        }
    }
    
    private let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOpacity = 4
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    }()
    
    private let nameLabel = CustomLabel(font: .poppinsFont(size: 22, weight: .regular))
    private let priceLabel = CustomLabel(font: .poppinsFont(size: 20, weight: .medium), alignment: .center)
    //TODO: CHECKMARK
    
    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let amountTextField = AmountTextField()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.tintColor = .maingreen
        button.addTarget(self, action: #selector(didTapMinusButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .maingreen
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "uncheckbox"), for: .normal)
        button.addTarget(self, action: #selector(checkDidTapPressed), for: .touchUpInside)
        return button
    }()
    
    override func setupCell() {
        super.setupCell()
        setupUI()
        configureAmountTextField()
    }
    
    private func configureAmountTextField() {
        amountTextField.backgroundColor = .lightgreen
        amountTextField.setLeftView(view: minusButton)
        amountTextField.setRightView(view: plusButton)
        amountTextField.layer.cornerRadius = 13
        amountTextField.text = "23"
//        amountTextField.delegate = self
    }

    @objc
    private func didTapMinusButton() {
     //   delegate?.didTapMinusButton(in: self)
    }
    
    @objc
    private func didTapPlusButton() {
      //  delegate?.didTapPlusButton(in: self)
    }
    
    @objc
    private func checkDidTapPressed() {
        let uncheckedImage = UIImage(named: "uncheckbox")
        let checkedImage = UIImage(named: "checkbox")
        
        
        let buttonImage = checkButton.imageView?.image == uncheckedImage ? checkedImage : uncheckedImage
        checkButton.setImage(buttonImage, for: .normal)
    }
//
//    @objc
//    private func textDidChange(_textfield: UITextField) {
//        delegate?.didUpdateText(in: self, newText: amountTextField.text ?? "")
//    }
    
    private func setupUI() {
                
        self.anchor(view: containerView) { kit in
            kit.leading(5)
            kit.trailing(5)
            kit.top(10)
            kit.bottom(10)
         //   kit.height(80)
        }
     
        containerView.anchor(view: itemImageView) { kit in
            kit.centerY()
            kit.leading(15)
            kit.width(50)
        }
        
        containerView.anchor(view: nameLabel) { kit in
            kit.leading(itemImageView.trailingAnchor, 15)
            kit.top(containerView.topAnchor, 5)
        }
        
        containerView.anchor(view: amountTextField) { kit in
            kit.leading(nameLabel.leadingAnchor)
            kit.top(nameLabel.bottomAnchor, 5)
            kit.width(150)
            kit.height(35)
        }
        
        containerView.anchor(view: checkButton) { kit in
            kit.trailing(15)
            kit.centerY()
        }
        containerView.anchor(view: priceLabel) { kit in
            kit.trailing(checkButton.leadingAnchor, 15)
            kit.centerY()
        }
    }
}

//extension ItemCell: UITextFieldDelegate {
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        delegate?.didUpdateText(in: self, newText: amountTextField.text ?? "")
//    }
//}

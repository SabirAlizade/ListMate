//
//  CheckBox.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import UIKit

final class CheckBox: UIControl {
    
    private lazy var checkedView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        return view
    }()
    
    var isChecked: Bool = false {
        didSet {
            updateState()
        }
    }
    
    var hitRadiusOffset:  CGFloat = 10
    
    var checkedViewInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) {
        didSet {
            layoutIfNeeded()
        }
    }
    
    var checkedBackgroundColor: UIColor = .lightGreen {
        didSet {
            updateBackgroundColor()
        }
    }
    
    var uncheckedBackgroundColor: UIColor = .lightGreen {
        didSet {
            updateBackgroundColor()
        }
    }
    
    var checkedImage: UIImage? = UIImage(systemName: "checkmark") {
        didSet {
            checkedView.image = checkedImage?.withRenderingMode(.alwaysTemplate)
            tintColor = .mainGreen
        }
    }
    
    var checkedBorderColor: UIColor = .mainGreen {
        didSet {
            updateBorderColor()
        }
    }
    
    var uncheckedBorderColor: UIColor = .mainGreen {
        didSet {
            updateBorderColor()
        }
    }
    
    var imageTint: UIColor? = .mainGreen {
        didSet {
            checkedView.tintColor = imageTint
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup UI
    
    private func setup() {
        backgroundColor = uncheckedBackgroundColor
        layer.borderColor = uncheckedBorderColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        addSubview(checkedView)
    }
    
    private func updateState() {
        updateBackgroundColor()
        updateBorderColor()
        checkedView.isHidden = !isChecked
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        checkedView.frame = CGRect(
            x: checkedViewInsets.left,
            y: checkedViewInsets.top,
            width: frame.width - checkedViewInsets.left - checkedViewInsets.right,
            height: frame.height - checkedViewInsets.top - checkedViewInsets.bottom
        )
    }
    
    private func updateBorderColor() {
        layer.borderColor = isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor
    }
    
    private func updateBackgroundColor() {
        backgroundColor = isChecked ? checkedBackgroundColor : uncheckedBackgroundColor
    }
    
    
    // MARK: - Touches Handling
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        sendActions(for: .valueChanged)
        isChecked.toggle()
    }
    
    // MARK: - Hit Area Increasing
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.inset(by: UIEdgeInsets(top: -hitRadiusOffset, left: -hitRadiusOffset, bottom: -hitRadiusOffset, right: -hitRadiusOffset)).contains(point)
    }
}



//
//  CheckBox.swift
//  ListMate
//
//  Created by Sabir Alizade on 23.12.23.
//

import UIKit

class CheckBox: UIControl {
    
    let checkedView: UIImageView = {
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

    var checkedBackgroundColor: UIColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1) {
        didSet {
            backgroundColor = isChecked ? checkedBackgroundColor : uncheckedBackgroundColor
        }
    }

    var uncheckedBackgroundColor: UIColor = .white {
        didSet {
            backgroundColor = isChecked ? checkedBackgroundColor : uncheckedBackgroundColor
        }
    }

    var checkedImage: UIImage? = UIImage(systemName: "checkmark") {
        didSet {
            checkedView.image = checkedImage?.withRenderingMode(.alwaysTemplate)
        }
    }

    var checkedBorderColor: UIColor = .black {
        didSet {
            layer.borderColor = isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor
        }
    }

    var uncheckedBorderColor: UIColor = .black {
        didSet {
            layer.borderColor = isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor
        }
    }

    var imageTint: UIColor? = .white {
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

    func setup() {
        backgroundColor = uncheckedBackgroundColor
        layer.borderColor = uncheckedBorderColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        addSubview(checkedView)
    }

    func updateState() {
        backgroundColor = isChecked ? checkedBackgroundColor : uncheckedBackgroundColor
        layer.borderColor = isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor
        checkedView.isHidden = !isChecked
    }

    //MARK: - handle touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        sendActions(for: .valueChanged)
        isChecked.toggle()
    }

    //MARK: - Increase hit area
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.inset(by: UIEdgeInsets(top: -hitRadiusOffset, left: -hitRadiusOffset, bottom: -hitRadiusOffset, right: -hitRadiusOffset)).contains(point)
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
}
    


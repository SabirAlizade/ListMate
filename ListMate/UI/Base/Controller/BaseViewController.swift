//
//  BaseViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackgroundColor()
        setupUIComponents()
        setupUIConstraints()
    }
    
    func setupUIComponents() {}
    func setupUIConstraints() {}
    
    func closeBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapDismiss))
    }
    
    func imagePickerButtons(takePictureAction: @escaping () -> Void, presentPickerAction: @escaping () -> Void) -> UIMenu {
        lazy var takePicButton = UIAction(title: "Take image", image: UIImage(systemName: "camera")) { action in
            takePictureAction()
        }
        lazy var choosePicButton = UIAction(title: "Choose from gallery", image: UIImage(systemName: "photo.on.rectangle")) { action in
            presentPickerAction()
        }
        
        lazy var buttons: [UIAction] = [takePicButton, choosePicButton]
        lazy var menuButtons = UIMenu(title: "Choose option", children: buttons)
        
        return menuButtons
    }
    
    @objc
    private func didTapDismiss() {
        dismiss(animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

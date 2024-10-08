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
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapDismiss)
        )
    }
}

extension BaseViewController {
    
    func imagePickerButtons(takePictureAction: @escaping () -> Void, presentPickerAction: @escaping () -> Void) -> UIMenu {
        lazy var takePicButton = UIAction(title: LanguageBase.imagePicker(.takeImage).translate, image: UIImage(systemName: "camera")) { action in
            takePictureAction()
        }
        lazy var choosePicButton = UIAction(title: LanguageBase.imagePicker(.selectFromGallery).translate, image: UIImage(systemName: "photo.on.rectangle")) { action in
            presentPickerAction()
        }
        
        return UIMenu(
            title: LanguageBase.imagePicker(.chooseOption).translate,
            children: [takePicButton, choosePicButton]
        )
    }
    
    @objc
    private func didTapDismiss() {
        dismiss(animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

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
    
    @objc
    private func didTapDismiss() {
        dismiss(animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

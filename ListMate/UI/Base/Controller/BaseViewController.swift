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
}

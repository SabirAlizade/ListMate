//
//  Controller+Ext.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

extension UIViewController {
    
    func setupLargeTitle(title: String, isLargeTitle: Bool = true) {
        self.title = title
        navigationController?.navigationBar.prefersLargeTitles = isLargeTitle
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func customBackgroundColor() {
        self.view.backgroundColor = .maingray
    }
}

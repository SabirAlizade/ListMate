//
//  Controller+Ext.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

extension UIViewController {
    
    func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        okAction.setValue(UIColor.maingreen, forKey: "titleTextColor")

        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func setupLargeTitle(title: String, isLargeTitle: Bool = true) { //TODO: CHECK
        self.title = title
        navigationController?.navigationBar.prefersLargeTitles = isLargeTitle
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func customBackgroundColor() {
        self.view.backgroundColor = .maingray
    }
}

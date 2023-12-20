//
//  UITableVIew+Ext.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ type: T.Type) {
        self.register(type.self, forCellReuseIdentifier: type.description())
    }
    
    func reuseCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.description(),
                                             for: indexPath) as? T else { return T() }
        return cell
    }
}

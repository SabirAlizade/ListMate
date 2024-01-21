//
//  UITableVIew+Ext.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.12.23.
//

import UIKit

class SwipeActionsHandler {

    static func configureSwipeAction(for tableView: UITableView, at indexPath: IndexPath, actionHandler: @escaping () -> Void) -> UISwipeActionsConfiguration {
        let action = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            actionHandler()
            completionHandler(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true

        action.backgroundColor = .textfieldback
        action.image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysOriginal)

        return configuration
    }
}

//
//  ListViewController.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class ListViewController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
     //   setupLargeTitle(title: "List")
    }
    
    override func setupUIConstraints() {
        super.setupUIConstraints()
    }
}


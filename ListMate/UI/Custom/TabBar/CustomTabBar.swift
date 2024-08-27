//
//  CustomTabBar.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.12.23.
//

import UIKit

class CustomTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        let listTab = UINavigationController(rootViewController: ListViewController())
        listTab.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "list"),
            selectedImage: UIImage(named: "listSelected")
        )
        
        let catalogTab = UINavigationController(rootViewController: CatalogViewController())
        catalogTab.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "catalog"),
            selectedImage: UIImage(named: "catalogSelected")
        )
        
        viewControllers = [listTab, catalogTab]
    }
}

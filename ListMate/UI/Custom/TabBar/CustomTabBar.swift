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
        listTab.tabBarItem = UITabBarItem(title: nil,
                                          image: UIImage(named: "list"),
                                          selectedImage: UIImage(named: "listSelected"))
        
        let historyTab = UINavigationController(rootViewController: CatalogViewController())
        historyTab.tabBarItem = UITabBarItem(title: nil,
                                          image: UIImage(named: "history"),
                                          selectedImage: UIImage(named: "historySelected"))
        
//        let profileTab = UINavigationController(rootViewController: ProfileViewController())
//        profileTab.tabBarItem = UITabBarItem(title: nil,
//                                          image: UIImage(named: "profile"),
//                                          selectedImage: UIImage(named: "profileSelected"))
        
        viewControllers = [listTab, historyTab]
    }
}

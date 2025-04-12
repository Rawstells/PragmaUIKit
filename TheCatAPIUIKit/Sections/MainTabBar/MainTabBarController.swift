//
//  MainTabBarController.swift
//  TheCatAPIUIKit
//
//  Created by joan on 04/04/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        customizeAppearance()
    }
    
    private func setupViewControllers() {
        let breedsVC = UINavigationController(rootViewController: CatBreedsViewController())
        breedsVC.tabBarItem = UITabBarItem(
            title: "Razas",
            image: UIImage(systemName: "pawprint"),
            tag: 0
        )
        
        let favoritesVC = UINavigationController(rootViewController: CatFavoritesViewController())
        favoritesVC.tabBarItem = UITabBarItem(
            title: "Favoritos",
            image: UIImage(systemName: "heart.fill"),
            tag: 1
        )
        
        self.viewControllers = [breedsVC, favoritesVC]
    }
    
    private func customizeAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray2
    }
}

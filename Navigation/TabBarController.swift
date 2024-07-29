//
//  TabBarController.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 15.06.2024.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tabBar.barTintColor = UIColor(resource: .ypBlack)
      
        let imagesListViewController = ImagesListViewController()
        let imagesNavigationController = UINavigationController(rootViewController: imagesListViewController)
        imagesNavigationController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesNavigationController, profileNavigationController]
        
        tabBar.tintColor = UIColor(resource: .ypWhite)
        if let whiteColor = UIColor(named: "ypWhite") {
            tabBar.unselectedItemTintColor = whiteColor.withAlphaComponent(0.5)
        }
    }
}



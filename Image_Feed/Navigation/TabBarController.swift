//
//  TabBarController.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 15.06.2024.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = UIColor(resource: .ypBlack)
       
        if let items = tabBar.items {
            for item in items {
                item.image = item.image?.withRenderingMode(.alwaysTemplate)
                item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysTemplate)
            }
        }
               
        tabBar.tintColor = UIColor(resource: .ypWhite)
        
        if let whiteColor = UIColor(named: "ypWhite") {
                tabBar.unselectedItemTintColor = whiteColor.withAlphaComponent(0.5)
        }
    }
}
    



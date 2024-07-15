//
//  NavigationBarController.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 15.06.2024.
//

import Foundation
import UIKit

final class NavigationBarController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIColor(named: "ypBlack") != nil {
            navigationBar.barTintColor = .ypBlack
        }
        
        if UIColor(named: "ypWhite") != nil {
            navigationBar.tintColor = .ypWhite
        }
    }
}

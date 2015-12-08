//
//  TabBarController.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 8/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = UIColor(rgba: "#207BF6")
    }
    
}

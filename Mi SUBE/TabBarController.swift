//
//  TabBarController.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 8/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class TabBarController: UITabBarController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the default color of the icon of the selected UITabBarItem and Title
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        // set the default color of the text for normal state
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)

        // Sets the default color of the background of the UITabBar
        UITabBar.appearance().barTintColor = UIColor(rgba: "#207BF6")
        
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 5 items) and the height of the tabBar)
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(UIColor(rgba: "#236ED6"), size: CGSizeMake(tabBar.frame.width/3, tabBar.frame.height))

        // Uses the original colors for your images, so they aren't not rendered as grey automatically.
        for item in (self.tabBar.items as [UITabBarItem]!)! {
            if let image = item.image {
                item.image = image.imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
    
    // block autorotate
    override func shouldAutorotate() -> Bool {
        return false
    }
}

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
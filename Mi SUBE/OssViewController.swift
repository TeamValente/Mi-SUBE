//
//  OssViewController.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 30/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit

class OssViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openLink(sender: UIButton) {
        switch(sender.tag) {
            case 1 :
                if let cocoapodsLink = NSURL(string: "https://cocoapods.org") {
                    UIApplication.sharedApplication().openURL(cocoapodsLink)
                }
            case 2 :
                if let realmLink = NSURL(string: "https://realm.io") {
                    UIApplication.sharedApplication().openURL(realmLink)
                }
            case 3 :
                if let uicolorLink = NSURL(string: "https://github.com/yeahdongcn/UIColor-Hex-Swift") {
                    UIApplication.sharedApplication().openURL(uicolorLink)
                }
            case 4 :
                if let progressLink = NSURL(string: "https://github.com/kentya6/KYCircularProgress") {
                    UIApplication.sharedApplication().openURL(progressLink)
                }
            default:
                print("tag erroneo!")
            
        }
    
    }
    
}

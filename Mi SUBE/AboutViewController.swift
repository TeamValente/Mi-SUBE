//
//  AboutViewController.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 23/1/16.
//  Copyright © 2016 Hernan Matias Coppola. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let url = NSURL(string: "http://misube.com/about.html")
        let requestObj = NSURLRequest(URL: url!)
        aboutWebView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

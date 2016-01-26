//
//  ChangelogViewController.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 1/26/16.
//  Copyright © 2016 Hernan Matias Coppola. All rights reserved.
//

import UIKit

class ChangelogViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var changesWebview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        changesWebview.delegate = self
        
        let url = NSURL(string: "http://misube.com/about.html")
        let requestObj = NSURLRequest(URL: url!)
        changesWebview.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url: NSURL = request.URL!
        let isExternalLink: Bool = url.scheme == "http" || url.scheme == "https" || url.scheme == "mailto"
        if (isExternalLink && navigationType == UIWebViewNavigationType.LinkClicked) {
            return !UIApplication.sharedApplication().openURL(request.URL!)
        } else {
            return true
        }
    }
}

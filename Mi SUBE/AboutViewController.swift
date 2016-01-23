//
//  AboutViewController.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 23/1/16.
//  Copyright © 2016 Hernan Matias Coppola. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var aboutWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        aboutWebView.delegate = self
        
        let url = NSURL(string: "http://misube.com/about.html")
        let requestObj = NSURLRequest(URL: url!)
        aboutWebView.loadRequest(requestObj)
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

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
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        aboutWebView.delegate = self
        
        let url = URL(string: "http://misube.com/about.html")
        let requestObj = URLRequest(url: url!)
        aboutWebView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url: URL = request.url!
        let isExternalLink: Bool = url.scheme == "http" || url.scheme == "https" || url.scheme == "mailto"
        if (isExternalLink && navigationType == UIWebViewNavigationType.linkClicked) {
            return !UIApplication.shared.openURL(request.url!)
        } else {
            return true
        }
    }
    
}

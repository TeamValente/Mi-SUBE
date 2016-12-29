//
//  OssViewController.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 30/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit

class OssViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var ossWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        ossWebView.delegate = self
        
        let url = URL(string: "http://misube.com/libs.html")
        let requestObj = URLRequest(url: url!)
        ossWebView.loadRequest(requestObj)
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

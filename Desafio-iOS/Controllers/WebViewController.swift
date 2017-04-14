//
//  WebViewController.swift
//  Desafio-iOS
//
//  Created by Leonardo Gouveia on 14/04/17.
//  Copyright © 2017 Leonardo Gouveia. All rights reserved.
//

import UIKit
import MBProgressHUD

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var gitURL: String!
    var loadingNotifications: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingNotifications = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotifications?.mode = MBProgressHUDMode.indeterminate
        loadingNotifications?.label.text = "Loading"

        
        webView.loadRequest(URLRequest(url: URL(string: self.gitURL)!))
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingNotifications?.hide(animated: true)
    }
    
}

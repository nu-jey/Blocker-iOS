//
//  PostcodeServiceView.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/09/01.
//

import Foundation

import
UIKit
import
WebKit

class ViewController: UIViewController, WKUIDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        webView()
    }
    func webView()
    {
        guard let htmlFileURL = Bundle.main.path(forResource:"postcode", ofType:"html")
        else {
            return
        }
        
        let gitURL = URL(string:"https://namsoo5.github.io/pracPostcode")!
        let url = gitURL
        let request = URLRequest (url: url)
        let configure = WKWebViewConfiguration()
        
        let contentController =  WKUserContentController()
        contentController.add(self, name:"callBackHandler")
        configure.userContentController = contentController
        
        let webview = WKWebView(frame:UIScreen.main.bounds, configuration: configure)
        webview.uiDelegate = self
        webview.navigationDelegate = self
        
        webview.load(request)
        view.addSubview(webview)
    }
}

extension ViewController: WKNavigationDelegate
{
    
}

extension ViewController: WKScriptMessageHandler
{
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
    {
        print("✅✅✅✅✅")
        print(message.name)
        if let data = message.body as? [String:Any] {
            print(data["address"])
            print(data["bcode"])
        }
    }
}

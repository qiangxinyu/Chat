//
//  WebViewController.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/12/14.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: RootViewController, WKUIDelegate, WKNavigationDelegate  {
    
    let webView = WKWebView.init()
    let progressView = UIProgressView()
    
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webView.frame = CGRect.init(x: 0, y: naviBarHeight, width: kScreenWidth, height: kScreenHeight - naviBarHeight)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        
        progressView.frame = webView.frame
        progressView.height = 2
        progressView.backgroundColor = UIColor.green
        view.addSubview(progressView)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        if let url = url {
            var path = url.absoluteString
            if !path.hasPrefix("http") {
                path = "http://\(path)"
            }
            webView.load(URLRequest.init(url: URL.init(string: path)!))
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            if progressView.progress == 1 {
                UIView.animate(withDuration: 0.3, animations: {[weak self] in
                    self?.progressView.alpha = 0
                })
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//
//        if navigationResponse.response.isKind(of: HTTPURLResponse.self) {
//            let response = navigationResponse.response as! HTTPURLResponse
//            print(response.statusCode)
//        }
//
//        decisionHandler(.allow)
//    }
//
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//
//         let e = error as NSError
//        if e.code == -1001 { //超时
//
//        } else if e.code == -1003 { // 服务器找不到
//
//        } else if e.code == -1100 { //链接找不到
//
//        }
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

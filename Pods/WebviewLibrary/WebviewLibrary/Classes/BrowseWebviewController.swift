//
//  BrowseWebviewController.swift
//  
//
//  Created by waitwalker on 2021/1/27.
//

import UIKit
import WebKit

@available(iOS 13.0, *)
public class BrowseWebviewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    /// URL链接
    private var url: String! = ""
    /// 导航栏标题
    private var navTitle: String?
    
    /// webview
    private var webview: WKWebView!
    
    /// 刷新按钮
    private var refreshButton: UIButton!
    
    /// 进度条
    private var progressView: UIProgressView!
    
    /// 构造函数
    public convenience init(_ url: String, title: String?) {
        self.init()
        self.url = url
        self.navTitle = title
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        print("url:\(url!)")
        
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = true
        // 指示HTML5视频是否内联播放或使用本机全屏控制器 默认false
        config.allowsInlineMediaPlayback = true
        
        webview = WKWebView(frame: self.view.bounds, configuration: config)
        webview.uiDelegate = self
        webview.navigationDelegate = self
        webview.load(URLRequest(url: URL(string: url)!))
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.view.addSubview(webview)
        webview.isHidden = false
        
        self.navigationItem.title = navTitle
        
        let progressView: UIProgressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 10))
        progressView.tintColor = .red
        progressView.trackTintColor = .orange
        self.progressView = progressView
        
        
        let backButton: UIButton = UIButton()
        backButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        backButton.setImage(UIImage.bundledImage("browse_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        let leftItem: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftItem
        
        
        let rButton: UIButton = UIButton()
        rButton.setImage(UIImage.bundledImage("browse_refresh"), for: .normal)
        rButton.frame = CGRect(x: (self.view.bounds.width - 100) / 2.0, y: (self.view.bounds.height - 100) / 2.0, width: 100.0, height: 100.0)
        rButton.isHidden = true
        rButton.addTarget(self, action: #selector(refreshButtonAction), for: .touchUpInside)
        self.view.addSubview(rButton)
        self.refreshButton = rButton
        
        self.view.bringSubviewToFront(progressView)
    }
    
    @objc func backButtonAction() -> Void {
        if webview != nil {
            if webview.canGoBack {
                webview.goBack()
            } else {
                self.navigationController?.dismiss(animated: true, completion: {
                    
                })
            }
        } else {
            self.navigationController?.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    @objc func refreshButtonAction() -> Void {
        self.refreshButton.isHidden = true
        self.webview.isHidden = false
        self.webview.reload()
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print("\(webview.estimatedProgress)")
            progressView.setProgress(Float(webview.estimatedProgress), animated: true)
            if webview.estimatedProgress == 1.0 {
                self.progressView.isHidden = false
            }
        }
    }
    
    /// ************ WKUIDelegate *************
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void)")
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void)")
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void)")
    }
    
    
    public func webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo) {
        print("webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo)")
    }
    
    public func webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo) {
        print("webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo)")
    }
    
    public func webView(_ webView: WKWebView, contextMenuForElement elementInfo: WKContextMenuElementInfo, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
        print("webView(_ webView: WKWebView, contextMenuForElement elementInfo: WKContextMenuElementInfo, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating)")
    }
    
//    public func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
//        print("webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void)")
//    }
    
    /// 关闭
    public func webViewDidClose(_ webView: WKWebView) {
        print("webViewDidClose(_ webView: WKWebView)")
    }
    
    /// ************ WKNavigationDelegate *************
//    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        print("webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)")
//    }
//    
//    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        print("webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)")
//    }
//    
//    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
//        print("webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void)")
//    }
    
//    public func webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void) {
//        print("webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void)")
//    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)")
        self.progressView.isHidden = false
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!)")
    }
    
//    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        print("webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)")
//    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)")
        self.webview.isHidden = true
        self.refreshButton.isHidden = false
        self.progressView.isHidden = true
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("webView(_ webView: WKWebView, didCommit navigation: WKNavigation!)")
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("webView(_ webView: WKWebView, didCommit navigation: WKNavigation!)")
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)")
    }
    
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("webViewWebContentProcessDidTerminate")
    }
    
}

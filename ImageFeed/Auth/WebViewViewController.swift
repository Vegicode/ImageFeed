//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Mac on 06.08.2024.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController{
    
    @IBOutlet var webView: WKWebView!
    
    @IBOutlet var progressView: UIProgressView!
    weak var delegate: WebViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        loadWebView()
        
        webView.navigationDelegate = self
       
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button") // 1
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button") // 2
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // 3
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack") // 4
    }
    
    enum WebViewConsants{
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
}
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, 
                 decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       
        
        if let code = fetchCode(url: navigationAction.request.url) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

private extension WebViewViewController {
    func loadWebView(){
        
        var components = URLComponents(string: "https://unsplash.com/oauth/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        if let url = components?.url{
            
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func fetchCode(url: URL?) -> String?{
        guard let url = url,
              let components = URLComponents(string: url.absoluteString),
              components.path == "/oauth/authorize/native",
              let item = components.queryItems?.first(where: {$0.name == "code"}) else { return nil }
              
        return item.value
        
    }
}

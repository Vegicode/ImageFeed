//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Mac on 26.09.2024.
//

import Foundation

fileprivate let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

 protocol WebViewPresenterProtocol {
     var view: WebViewViewControllerProtocol? {get set}
     func viewDidLoad()
     func didUpdateProgressValue(_ newValue: Double)

}

final class WebViewPresenter: WebViewPresenterProtocol {
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
        
    }
    func shouldHideProgress(for value: Float) -> Bool {
            abs(value - 1.0) <= 0.0001
        }
    
    func viewDidLoad() {
        loadWebView()
        didUpdateProgressValue(0)
        
    }
    
    var view: WebViewViewControllerProtocol?
    
    func loadWebView(){
        
        guard var components = URLComponents(string: unsplashAuthorizeURLString) else {
            print("Ошибка")
            return
        }
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = components.url else{
            print("Ошибка")
            return
        }
        let request = URLRequest(url: url)
        view?.load(request: request)
    }
}

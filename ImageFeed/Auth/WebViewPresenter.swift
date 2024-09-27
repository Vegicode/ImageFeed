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
     func code(from url: URL) -> String?

}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    var authHelper: AuthHelperProtocol
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
        
    }
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
        guard let request = authHelper.authRequest() else { return }
        
        view?.load(request: request)
        didUpdateProgressValue(0)
        
    }
    
    var view: WebViewViewControllerProtocol?
    
    
        
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}

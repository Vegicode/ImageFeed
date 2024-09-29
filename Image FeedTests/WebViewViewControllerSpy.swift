//
//  WebViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Mac on 26.09.2024.
//
@testable import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: (any ImageFeed.WebViewPresenterProtocol)?
    
    var loadRequsetCalled: Bool = false
    
    func load(request: URLRequest) {
        
        loadRequsetCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        <#code#>
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        <#code#>
    }
    
    
}

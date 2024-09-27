//
//  WebViewPresenterSpy.swift
//  Image FeedTests
//
//  Created by Mac on 26.09.2024.
//

@testable import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: (any ImageFeed.WebViewViewControllerProtocol)?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        <#code#>
    }
    
    func code(from url: URL) -> String? {
            return nil
        }
    
}

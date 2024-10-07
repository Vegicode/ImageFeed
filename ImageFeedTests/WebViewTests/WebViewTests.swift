//
//  Image_FeedTests.swift
//  Image FeedTests
//
//  Created by Mac on 26.09.2024.
//
@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    func testPresenterCallsLoadRequest() {
        
        
        let controller = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        controller.presenter = presenter
        presenter.view = controller
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(controller.loadRequsetCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        
        XCTAssertFalse(shouldHideProgress)
    }
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {

        let configuration = AuthConfiguration.standart
        let authHelper = AuthHelper(configuration: configuration)
        
        
        let url = authHelper.authURL()

        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }

        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL(){
        var components = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        components?.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = components?.url
        let authHelper = AuthHelper()
        
        let code = authHelper.code(from: url!)
        
      
        XCTAssertEqual(code, "test code")
    }
}

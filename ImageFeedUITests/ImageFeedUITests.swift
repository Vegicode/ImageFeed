//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Mac on 06.10.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app.launch()
    }
    func testAuth() throws {
        
        let authenticateButton = app.buttons["Authenticate"]
        XCTAssertTrue(authenticateButton.waitForExistence(timeout: 10))
        
        authenticateButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        
        loginTextField.tap()
        loginTextField.typeText("login@")
        app.buttons["Done"].tap()
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("password")
        sleep(1)
        app.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
           
           let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
           cell.swipeUp()
           
           sleep(2)
           
           let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
           
           cellToLike.buttons["likeButton"].tap()
           
           sleep(2)
           
           cellToLike.tap()
           
           sleep(2)
           
           let image = app.scrollViews.images.element(boundBy: 0)
           // Zoom in
           image.pinch(withScale: 3, velocity: 1) // zoom in
           // Zoom out
           image.pinch(withScale: 0.5, velocity: -1)
           
           let navBackButtonWhiteButton = app.buttons["backButton"]
           navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Name LastName"].exists)
        XCTAssertTrue(app.staticTexts["@..."].exists)
        
        app.buttons["ExitButton"].tap()
        
        let yesButton = app.alerts.buttons["Да"]
        XCTAssertTrue(yesButton.waitForExistence(timeout: 5))
        yesButton.tap()
        
        let loginButton = app.buttons["Authenticate"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 10))
        
        loginButton.tap()
    }
}

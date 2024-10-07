//
//  Profile.swift
//  ImageFeedUnitTests
//
//  Created by Mac on 07.10.2024.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    func testViewControllerDidTapLogOut() {
        //Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        presenter.logout()
        
        //Then
        XCTAssertTrue(presenter.isButtonTapped)
    }
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertTrue(presenter.isViewDidLoad)
    }
}

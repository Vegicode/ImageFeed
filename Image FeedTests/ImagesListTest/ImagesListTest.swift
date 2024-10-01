//
//  ImageListTest.swift
//  ImageListTest
//
//  Created by Mac on 30.09.2024.
//

import XCTest
@testable import ImageFeed

final class ImageListTest: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController as! any ImageListViewControllerProtocol
        //When
        _ = viewController.view
        
        //Then
        XCTAssertTrue(presenter.isViewDidLoadCall)
    }
    
    func testGetCellHeightIsCalledCorrect() {
        //Given
        let vc = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        vc.presenter = presenter
        presenter.view = (vc as! any ImageListViewControllerProtocol)
        let photo = Photo(id: "1", size: CGSize(width: 100, height: 200), createdAt: Date(), welcomeDescription: "test", thumbImageURL: "url1", largeImageURL: "url2", isLiked: false)
        presenter.photos = [photo]
        let indexPath = IndexPath(row: 0, section: 0)
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        
        // When
        let cellHeight = presenter.getCellHeight(indexPath: indexPath, tableView: tableView)
        
        // Then
        XCTAssertEqual(cellHeight, 0)
    }

}

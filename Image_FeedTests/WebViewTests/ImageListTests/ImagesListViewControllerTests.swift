//
//  ImagesListViewControllerTests.swift
//  ImagesListViewControllerTests
//
//  Created by Evgenia Kucherenko on 11.08.2024.
//

import XCTest
@testable import Image_Feed


final class ImagesListViewControllerTests: XCTestCase {

    func testChangeLike() {
        
        //Given
        let expectation = XCTestExpectation(description: "Change like")
        let presenter = ImagesListViewPresenterSpy()
        
        //When
        presenter.changeLike(photoId: "PhotoId", isLiked: true) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
            
        //Then
        XCTAssertTrue(presenter.isLiked)
    }

    func testViewDidLoad() {
        
        //Given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        
        //When
        presenter.viewDidLoad()
        
        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testNotificationObserver() {
        
        //Given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        presenter.notificationObserver()
        
        //Then
        XCTAssertTrue(presenter.notificationObserverCalled)
    }
    
    func testUpdateTableViewAnimated() {
        
        //Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenterSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        
        //When
        viewController.updateTableViewAnimated()
        
        //Then
        XCTAssertTrue(viewController.tableViewUpdatesCalled)
    }
}

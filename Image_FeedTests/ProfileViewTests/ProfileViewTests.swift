//
//  ProfileViewTests.swift
//  Image_FeedTests
//
//  Created by Evgenia Kucherenko on 11.08.2024.
//

import XCTest
@testable import Image_Feed

final class ProfileViewTests: XCTestCase {
    
    func testUpdateProfileDetails() {
        
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
            
        // When
        presenter.updateProfileDetails()
            
        // Then
        XCTAssertTrue(presenter.updateProfileDetailsCalled)
    }
    
    func testUpdateAvatar() {
        
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        
        // When
        presenter.updateAvatar()
        
        // Then
        XCTAssertTrue(presenter.updateAvatarCalled)
    }
    
    func testLogout() {
        
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        
        // When
        presenter.logout()
        
        // Then
        XCTAssertTrue(presenter.logoutCalled)
    }
}

//
//  ProfileViewPresenterSpy.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 11.08.2024.
//

import Foundation

final class ProfileViewPresenterSpy: ProfilePresenterProtocol {
    var view: (any ProfileViewControllerProtocol)?
    
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var logoutCalled = false
    
    func updateProfileDetails() {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func logout() {
        logoutCalled = true
    }
    
    func logoutConfirmed() {
    }
}

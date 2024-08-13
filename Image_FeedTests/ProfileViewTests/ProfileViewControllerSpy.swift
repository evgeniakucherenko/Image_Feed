//
//  ProfileViewControllerSpy.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 11.08.2024.
//

import Foundation
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var showAlertCalled = false
    
    func updateProfileDetails(profile: Profile) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar(imageURL: URL) {
        updateAvatarCalled = true
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        showAlertCalled = true
    }
}

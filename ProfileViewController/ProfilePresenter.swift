//
//  ProfilePresenter.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 10.08.2024.
//

import Foundation
import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }

    func updateProfileDetails()
    func updateAvatar()
    func logout()
    func logoutConfirmed()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: (any ProfileViewControllerProtocol)?
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared

    func updateProfileDetails() {
        guard let profileResult = profileService.profileInfo else { return }
        
        let name = [profileResult.first_name,
                    profileResult.last_name].compactMap { $0 }.joined(separator: " ")
        let loginName = "@" + profileResult.username
        let profile = Profile(
            username: profileResult.username,
            name: name,
            loginName: loginName,
            email: profileResult.email,
            bio: profileResult.bio
        )
        
        view?.updateProfileDetails(profile: profile)
    }
    
    func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.profileImage?.profile_image.small,
              let url = URL(string: profileImageURL) else { return }
       
        view?.updateAvatar(imageURL: url)
    }
    
    func logout() {
        let yesAction = UIAlertAction(
            title: "Да",
            style: .default) { [weak self] _ in
                self?.logoutConfirmed()
            }
        
        let noAction = UIAlertAction(
            title: "Нет",
            style: .cancel,
            handler: nil
        )
        
        view?.showAlert(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            actions: [yesAction, noAction]
        )
    }
    
    func logoutConfirmed() {
        profileLogoutService.logout()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        } else {
            assertionFailure("Invalid Configuration")
        }
    }
}

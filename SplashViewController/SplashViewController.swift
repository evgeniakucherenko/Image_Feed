//
//  SplashViewController.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 07.07.2024.
//

import Foundation
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let oAuth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .logo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .ypBlack)
        view.addSubview(imageView)
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oAuth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            presentAuthViewController()
        }
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func presentAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = TabBarController()
        
        let imagesListViewController = ImagesListViewController()
        let imagesNavigationController = UINavigationController(rootViewController: imagesListViewController)
        imagesNavigationController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        tabBarController.viewControllers = [imagesNavigationController, profileNavigationController]
        
        tabBarController.tabBar.barTintColor = UIColor(resource: .ypBlack)
        tabBarController.tabBar.tintColor = UIColor(resource: .ypWhite)
        if let whiteColor = UIColor(named: "ypWhite") {
            tabBarController.tabBar.unselectedItemTintColor = whiteColor.withAlphaComponent(0.5)
        }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        
        oAuth2Service.fetchOAuthToken(for: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
                case .success(let accessToken):
                    self.oAuth2TokenStorage.token = accessToken
                    self.didAuthenticate()
                case .failure(let error):
                    print("[SplashViewController]: \(error)")
                    break
            }
        }
    }
    
    private func didAuthenticate() {
        guard let token = self.oAuth2TokenStorage.token else {
            print("[SplashViewController]: Failed to obtain token after authentication")
            return
        }
        fetchProfile(token: token)
    }
    
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) { result in
            switch result {
            case .success(let profileResult):
                let username = profileResult.username
                self.fetchProfileImage(token, username)
            case .failure(let error):
                print("[SplashViewController]: \(error.localizedDescription)")
                break
            }
        }
    }
    
    func fetchProfileImage(_ token: String, _ username: String) {
        profileImageService.fetchProfileImage(token, username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.switchToTabBarController()
            case .failure(let error):
                print("[SplashViewController]: \(error.localizedDescription)")
            }
        }
    }
}

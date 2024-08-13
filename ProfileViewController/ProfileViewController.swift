//
//  ProfileViewController.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 14.06.2024.
//

import Foundation
import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func updateProfileDetails(profile: Profile)
    func updateAvatar(imageURL: URL)
    func showAlert(title: String, message: String, actions: [UIAlertAction])
}

final class ProfileViewController: UIViewController {
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileDidChangeObserver: NSObjectProtocol?
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - UI Elements
    private let profilePhoto: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .profile))
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "ekaterina_nov"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
   
    private let logoutButton: UIButton = {
        let button = UIButton()
        let image = UIImage(resource: .logoutButton)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "logoutButton"
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ProfilePresenter()
        presenter?.view = self
        
        setupViews()
        setupConstraints()
        setupObservers()
        
        presenter?.updateProfileDetails()
        presenter?.updateAvatar()
        
        view.backgroundColor = UIColor(resource: .ypBlack)
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        [profilePhoto,
         nameLabel,
         nicknameLabel,
         descriptionLabel,
         logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profilePhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePhoto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profilePhoto.widthAnchor.constraint(equalToConstant: 70),
            profilePhoto.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            logoutButton.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor)
        ])
    }
    
    private func setupObservers() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name("ProfileImageServiceDidChange"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.presenter?.updateAvatar()
        }
    }
    
    // MARK: - Profile logout
    @objc private func logoutButtonTapped() {
        presenter?.logout()
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func updateAvatar(imageURL: URL) {
        let placeholderImage = UIImage(resource: .userpickIcon)
        let processor = RoundCornerImageProcessor(radius: .point(61),
                                                  roundingCorners: .all,
                                                  backgroundColor: .clear)
        profilePhoto.clipsToBounds = true
        profilePhoto.kf.setImage(with: imageURL, placeholder: placeholderImage, options: [.processor(processor)])
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}

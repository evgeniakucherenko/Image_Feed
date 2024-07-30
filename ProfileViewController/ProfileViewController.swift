//
//  ProfileViewController.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 14.06.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileDidChangeObserver: NSObjectProtocol?
    
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
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = UIColor(resource: .ypBlack)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in guard let self = self else { return }
                self.updateAvatar()
        }
        
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
        updateProfileDetails(profile: profile)
        
        updateAvatar()
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
    
    func setupConstraints() {
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
}

extension ProfileViewController {
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImage?.profile_image.small,
            let url = URL(string: profileImageURL)
            else { return }
        
        let placeholderImage = UIImage(resource: .userpickIcon)
        let processor = RoundCornerImageProcessor(radius: .point(61),
                                                  roundingCorners: .all,
                                                  backgroundColor: .clear)
        profilePhoto.clipsToBounds = true
        profilePhoto.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)])
    }
}


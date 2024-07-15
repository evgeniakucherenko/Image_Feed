//
//  Profile.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 11.07.2024.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let email: String
    let bio: String?
    
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username 
        self.name = "\(profileResult.first_name) \(profileResult.last_name)"
        self.loginName = "@\(profileResult.username )"
        self.email = profileResult.email
        self.bio = profileResult.bio
    }
} 

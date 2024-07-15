//
//  ProfileResult.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 11.07.2024.
//

import Foundation

struct ProfileResult: Codable {
    let id: String
    let updated_at: String
    let username: String
    let first_name: String
    let last_name: String
    let twitter_username: String?
    let portfolio_url: String?
    let bio: String?
    let location: String?
    let total_likes: Int
    let total_photos: Int
    let total_collections: Int
    let followed_by_user: Bool
    let downloads: Int
    let uploads_remaining: Int
    let instagram_username: String?
    let email: String
}




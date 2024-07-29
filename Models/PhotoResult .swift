//
//  PhotoResult .swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 26.07.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let updatedAt: String?
    let width, height: Double
    let likes: Int
    let color: String
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, likes, color, description, urls
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case likedByUser = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let thumb: String
}

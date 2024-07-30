//
//  UserResult.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 12.07.2024.
//

import Foundation

struct ProfileImage: Codable {
    
    let profile_image: Imagesizes
       
    struct Imagesizes: Codable {
        let small: String?
        let medium: String?
        let large: String?
    }
}

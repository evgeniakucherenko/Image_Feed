//
//  Constants.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 06.07.2024.
//

import Foundation

enum Constants {
    static let accessKey = "I7hjg6jQxRdffhwFq0zv-ck-MGUOmjDMdQQzMVYTT_U"
    static let secretKey = "Dh6xT_l5rMsZlVQ7OjaPsw1-K5jUMZe1-y8ORnOhxg0"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

enum ProfileConstants {
    static let urlProfile = "https://api.unsplash.com/users/"
}

enum PhotoConstants {
    static let urlPhoto = "https://api.unsplash.com/"
}

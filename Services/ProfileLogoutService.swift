//
//  ProfileLogoutService.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 29.07.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
    }
    
    private func cleanCookies() {
        ProfileService.shared.cleanProfile()
        ProfileImageService.shared.cleanProfileImage()
        ImagesListService.shared.photos = []
        OAuth2TokenStorage.shared.cleanToken()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
          
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
             records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
             }
        }
    }
}

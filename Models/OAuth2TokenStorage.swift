//
//  OAuth2TokenStorage.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 07.07.2024.
//

import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
}

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    var token: String? {
        get {
            guard let token = KeychainWrapper.standard.string(forKey: "Auth token")  else {
                return nil
            }
            return token
        }
        
        set {
            guard let token = newValue else {
                return
            }
            KeychainWrapper.standard.set(token, forKey: "Auth token")
        }
    }
}

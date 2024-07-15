//
//  ProfileImageService.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 12.07.2024.
//

import Foundation
import UIKit

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let urlSession = URLSession.shared
  
    private var task: URLSessionTask?
    private var urlProfile = "https://api.unsplash.com/users/"
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private(set) var profileImage: ProfileImage?
    
    private init() {}
    
    func makeProfileImageRequest(token: String, username: String) -> URLRequest? {
        let imageUrlString = urlProfile + username
        guard let URL = URL(string: imageUrlString) else {
            preconditionFailure("Error")
        }
        var request = URLRequest(url: URL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchProfileImage(_ token: String, _ username: String, completion: @escaping (Result<ProfileImage, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard task == nil else { return }
        
        guard let token = oauth2TokenStorage.token else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        guard let request = makeProfileImageRequest(token: token, username: username) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<ProfileImage, Error>) in
            DispatchQueue.main.async {
                
                switch result {
                case.success(let decodedData):
                    self.profileImage = decodedData
                    self.task = nil
                    completion(.success(decodedData))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": decodedData])                    
                case .failure(let error):
                    self.task = nil
                    completion(.failure(error))
                    print("ProfileImageService: Error")
                }
            }
        }
        self.task = task
        task.resume()
    }
}


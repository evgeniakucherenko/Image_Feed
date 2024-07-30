//
//  ImagesListService.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 25.07.2024.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private init() {}
    
    var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let dateFormatterISO8601 = DateFormatterProvider.shared.iso8601DateFormatter
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private func makePageRequest(page: Int) -> URLRequest? {
        guard
            let URL = URL(string: PhotoConstants.urlPhoto + "/photos?page=\(page)"),
            let token = oauth2TokenStorage.token else {
            preconditionFailure("[ImagesListService]: Error: can't construct RequestUrl")
        }
        
        var request = URLRequest(url: URL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let requestWithPageNumber = makePageRequest(page: nextPage) else {
            print("[ImagesListService]: error in requestWithPageNumber")
            return
        }
        
        let task = urlSession.objectTask(for: requestWithPageNumber) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else {
                print("[ImagesListService]: fetchPhotoNextPage error with URLSession.shared.objectTask")
                return
            }
            switch result {
            case .success(let decodedData):
                var arrayOfPhotos: [Photo] = []
                decodedData.forEach { data in
                    let photo = Photo(
                        id: data.id,
                        size: CGSize(width: data.width, height: data.height),
                        createdAt: self.dateFormatterISO8601.date(from: data.createdAt ?? ""),
                        welcomeDescription: data.description,
                        thumbImageURL: data.urls.thumb,
                        largeImageURL: data.urls.full,
                        isLiked: data.likedByUser
                    )
                    arrayOfPhotos.append(photo)
                }
                DispatchQueue.main.async {
                    self.photos += arrayOfPhotos
                    self.lastLoadedPage = nextPage
                    self.task = nil
                    NotificationCenter.default
                        .post(name: ImagesListService.didChangeNotification,
                              object: self,
                              userInfo: ["URL": decodedData])
                }
            case .failure(let error):
                print("[ImagesListService]: \(error)")
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeLikeRequest(photoId: String) -> URLRequest? {
        guard
            let URL = URL(string: PhotoConstants.urlPhoto + "photos/\(photoId)/like"),
            let token = oauth2TokenStorage.token else {
            preconditionFailure("[ImagesListService]: Error: can't construct LikeRequest")
        }
        
        var request = URLRequest(url: URL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard task == nil else {
            print("[ImagesListService]: Task is already running, cannot change like status.")
            return
        }
        guard var likeRequest = makeLikeRequest(photoId: photoId) else {
            print("[ImagesListService]: can't construct likeRequest")
            return
        }
        
        likeRequest.httpMethod = isLike ? "DELETE" : "POST"
        
        DispatchQueue.global(qos: .background).async {
            let task = self.urlSession.objectTask(for: likeRequest) { [weak self] (result: Result<LikeResult, Error>) in
                guard let self = self else {
                    print("[ImagesListService]: error")
                    return
                }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                            let photo = self.photos[index]
                            let newPhoto = Photo(
                                id: photo.id,
                                size: photo.size,
                                createdAt: photo.createdAt,
                                welcomeDescription: photo.welcomeDescription,
                                thumbImageURL: photo.thumbImageURL,
                                largeImageURL: photo.largeImageURL,
                                isLiked: !photo.isLiked
                            )
                            self.photos[index] = newPhoto
                            completion(.success(()))
                            print("[ImagesListService]: Like status changed for photo id: \(photo.id)")
                        }
                    case .failure(let error):
                        completion(.failure(error))
                        print("[ImagesListService]: changeLike error with case .failure: \(error)")
                    }
                    self.task = nil
                }
            }
            self.task = task
            task.resume()
        }
    }
}

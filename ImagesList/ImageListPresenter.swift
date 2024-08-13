//
//  ImageListPresenter.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 11.08.2024.
//

import Foundation

public protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func viewDidLoad()
    func notificationObserver()
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        notificationObserver()
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    func notificationObserver() {
        NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in guard let self = self else { return }
        view?.updateTableViewAnimated()
        }
    }

    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        ImagesListService.shared.changeLike(photoId: photoId, isLike: isLiked) { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}

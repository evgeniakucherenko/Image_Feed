//
//  ViewController.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 30.05.2024.
//

import UIKit
import Foundation
import Kingfisher

final class ImagesListViewController: UIViewController {

    // MARK: - Properties
    private var photos: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private let tableView = UITableView()
    private let imagesListService = ImagesListService.shared
    private let date = Date()
    private let displayDateFormatter = DateFormatterProvider.shared.displayDateFormatter

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupObservers()
    }

    // MARK: - Setup Methods
    private func setupObservers() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)

        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if indexPath.row < photos.count {
            let photo = photos[indexPath.row]
            
            guard let imageUrl = URL(string: photo.thumbImageURL) else { return }
            guard let placeholderImage = UIImage(named: "placeholder") else { return }
            
            cell.contentImage.kf.setImage(with: imageUrl, placeholder: placeholderImage)
            
            let dateText = photo.createdAt != nil ? displayDateFormatter.string(from: photo.createdAt!) : ""
            cell.configure(with: placeholderImage, date: dateText, isLiked: photo.isLiked)
        }
    }

    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos

        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SingleImageViewController()
        let imageUrl = URL(string: photos[indexPath.row].largeImageURL)
        viewController.imageUrl = imageUrl
        viewController.modalPresentationStyle = .fullScreen // Убедитесь, что контроллер будет представлен на весь экран
        present(viewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource, ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell, completion: @escaping (Bool) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.photos = self.imagesListService.photos
                    let isLiked = self.photos[indexPath.row].isLiked
                    completion(isLiked)
                    UIBlockingProgressHUD.dismiss()
                case .failure(_):
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imagesListCell, with: indexPath)
        let thumbImageUrl = URL(string: photos[indexPath.row].largeImageURL)
        let imageView = imagesListCell.contentImage
        
        imagesListCell.delegate = self
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: thumbImageUrl, placeholder: UIImage(named: "placeholder")) { result in
            switch result {
            case .success(_):
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(_):
                break
            }
        }
        return imagesListCell
    }
}

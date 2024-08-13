//
//  SingleImageViewController.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 15.06.2024.
//

import Foundation
import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var imageUrl: URL? {
        didSet {
            guard isViewLoaded, let imageUrl = imageUrl else { return }
            loadImage()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBackground
        
        setupViews()
        setupConstraints()
        
        if let imageUrl = imageUrl {
            loadImage()
        }
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 3.0
        centerImage()
    }
    
    
    // MARK: UI elements
    lazy var singleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(resource: .backIcon)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.accessibilityIdentifier = "backButton"
        return button
    }()
    
    private lazy var sharingButton: UIButton = {
        let button = UIButton()
        let image = UIImage(resource: .sharingButton)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapShareButton(_ sender: UIButton) {
        guard let image = singleImage.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func loadImage() {
        guard let imageUrl = imageUrl else { return }
        
        UIBlockingProgressHUD.show()
        
        singleImage.kf.indicatorType = .activity
        singleImage.kf.setImage(with: imageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                self.rescaleAndCenterImageInScrollView(image: result.image)
            case .failure(let error):
                print("[SingleImageViewController]: \(error)")
                guard let image = UIImage(named: "placeholder") else { return }
                self.singleImage.image = image
                self.rescaleAndCenterImageInScrollView(image: image)
            }
        }
    }
    
    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = singleImage.frame.size
        
        let verticalInset = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalInset = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        centerImage()
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}

//MARK: - Setup Methods
extension SingleImageViewController {
    private func setupViews() {
        [scrollView,
         backButton,
         sharingButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        scrollView.addSubview(singleImage)
        singleImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
            singleImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            singleImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            singleImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            singleImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            singleImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            singleImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                            
            
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
                
            sharingButton.widthAnchor.constraint(equalToConstant: 50),
            sharingButton.heightAnchor.constraint(equalToConstant: 50),
            sharingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            sharingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

//
//  SingleImageViewController.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 15.06.2024.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image = image else { return }
            setImage()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image = UIImage(resource: ._0)
        view.backgroundColor = .ypBackground
        
        setupViews()
        setupConstraints()
        setImage()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 3.0
    }
    
    // MARK: UI elements
    lazy var singleImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: ._0))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(resource: .backIcon)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sharingButton: UIButton = {
        let button = UIButton()
        let image = UIImage(resource: .sharingButton)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(singleImage)
        view.addSubview(backButton)
        view.addSubview(sharingButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
            
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                
            singleImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            singleImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            singleImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            singleImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            singleImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            singleImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                            
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 28),
                
            sharingButton.widthAnchor.constraint(equalToConstant: 50),
            sharingButton.heightAnchor.constraint(equalToConstant: 50),
            sharingButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),
            sharingButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    // MARK: - Private Methods
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
    
    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = singleImage.frame.size
        
        let verticalInset = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalInset = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    private func setImage() {
        guard let image = image else { return }
        
        singleImage.image = image
        singleImage.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
}



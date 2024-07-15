//
//  ImagesListCell.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 02.06.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
   
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like_button_off"), for: .normal)
        return button
    }()
    
    let contentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
     let dateGradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .ypBlack
        gradientOverlay()
    }
    
    private func setupViews() {
        contentView.addSubview(contentImage)
        contentImage.addSubview(dateGradient)
        dateGradient.addSubview(dateLabel)
        contentImage.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            contentImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            dateGradient.leadingAnchor.constraint(equalTo: contentImage.leadingAnchor),
            dateGradient.trailingAnchor.constraint(equalTo: contentImage.trailingAnchor),
            dateGradient.bottomAnchor.constraint(equalTo: contentImage.bottomAnchor),
            dateGradient.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.leadingAnchor.constraint(equalTo: dateGradient.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: dateGradient.bottomAnchor, constant: -8),
            
            likeButton.trailingAnchor.constraint(equalTo: contentImage.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: contentImage.topAnchor)
        ])
    }
    
    private func gradientOverlay() {
        dateGradient.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        
        let dateGradientOverlay = CAGradientLayer()
        dateGradientOverlay.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.2).cgColor
        ]
        dateGradientOverlay.locations = [0, 1]
        dateGradientOverlay.frame = dateGradient.bounds
        
        dateGradient.layer.addSublayer(dateGradientOverlay)
    }
    
    func configure(with image: UIImage, date: String, isLiked: Bool) {
        contentImage.image = image
        dateLabel.text = date
        let likeImageName = isLiked ? "like_button_on" : "like_button_off"
        likeButton.setImage(UIImage(named: likeImageName), for: .normal)
    }
}

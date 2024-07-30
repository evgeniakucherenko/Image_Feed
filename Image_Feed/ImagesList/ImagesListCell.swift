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
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentImage: UIImageView!
    
    @IBOutlet weak var dateGradient: UIView! {
        didSet {
            gradientOverlay()
        }
    }
    
    private func gradientOverlay() {
        let dateGradientOverlay = CAGradientLayer()
        dateGradientOverlay.frame = dateGradient.bounds
        dateGradientOverlay.colors = [
            UIColor(resource: .ypBlack).withAlphaComponent(0).cgColor,
            UIColor(resource: .ypBlack).withAlphaComponent(0.2).cgColor
    ]
        dateGradientOverlay.locations = [0, 1]
        dateGradient.layer.addSublayer(dateGradientOverlay)
    }
}

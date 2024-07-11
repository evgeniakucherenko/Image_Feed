//
//  ViewController.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 30.05.2024.
//

import UIKit

final class ImagesListViewController: UIViewController, 
                                      UITableViewDelegate,
                                      UITableViewDataSource {
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private let date = Date()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let likeImage = indexPath.row % 2 == 0 ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        
        cell.dateLabel?.text = dateFormatter.string(from: date)
        cell.likeButton?.setImage(likeImage, for: .normal)
        cell.contentImage?.image = UIImage(named: photosName[indexPath.row]) ?? UIImage()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return .zero }
               
        let cellWidth = tableView.contentSize.width - 32
        let cellHeight = cellWidth / image.size.width * image.size.height
        return cellHeight + 8
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            let image = UIImage(named: photosName[indexPath.row])
            _ = viewController.view
            viewController.singleImage.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    } 
}

extension ImagesListViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
}


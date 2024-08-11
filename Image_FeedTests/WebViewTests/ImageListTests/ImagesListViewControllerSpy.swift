//
//  ImagesListViewControllerSpy.swift
//  Image_FeedTests
//
//  Created by Evgenia Kucherenko on 11.08.2024.
//

import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    
    var presenter: ImagesListViewPresenterProtocol?
    var tableViewUpdatesCalled: Bool =  false
    
    func updateTableViewAnimated() {
        tableViewUpdatesCalled = true
    }
}

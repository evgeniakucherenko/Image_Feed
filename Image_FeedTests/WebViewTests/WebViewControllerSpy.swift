//
//  WebViewPresenterSpy.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 10.08.2024.
//

import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: Image_Feed.WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {
    }

    func setProgressHidden(_ isHidden: Bool) {
    }
}

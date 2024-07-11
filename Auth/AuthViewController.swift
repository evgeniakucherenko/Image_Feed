//
//  AuthViewController.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 06.07.2024.
//

import Foundation
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    private let logoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .authScreenLogo))
        return imageView
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.ypBlack, for: .normal)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    override  func viewDidLoad() {
        view.backgroundColor = UIColor(resource: .ypBlack)
        setupViews()
        setupConstraints()
        loginButton.addTarget(self, action: #selector(self.didTapLoginButton), for: .touchUpInside)
        configureBackButton()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func setupViews() { 
        [logoView, loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.widthAnchor.constraint(equalToConstant: 343)])
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black") 
    }
    
    @objc private func didTapLoginButton() {
        performSegue(withIdentifier: showWebViewSegueIdentifier, sender: self)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}



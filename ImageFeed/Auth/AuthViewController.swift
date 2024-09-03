//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Mac on 06.08.2024.
//

import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}


final class AuthViewController: UIViewController{

    private let ShowWebViewSegueIdentifier = "ShowWebView"
    let oauth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)")}
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popToRootViewController(animated: true)
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            ProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                OAuth2TokenStorage().token = token
                print("token: \(token)")
                delegate?.authViewController(self, didAuthenticateWithCode: code)
            case .failure:
                print("fail")
            }
            
        }
    }
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
                    dismiss(animated: true)
                }
    
}

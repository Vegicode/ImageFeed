//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Mac on 06.08.2024.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController{

    private let ShowWebViewSegueIdentifier = "ShowWebView"
    private let storage = OAuth2TokenStorage()
    let oauth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    
    
    @IBOutlet var inButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        inButton.accessibilityIdentifier = "Authenticate"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)")
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    
    }
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self, let delegate = self.delegate else {
                print("Error: AuthController not exists or delegate is nil")
                return
            }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                self.storage.token = token
                print("token: \(token)")
                delegate.didAuthenticate(self)
            case .failure(let error):
                let alert = UIAlertController(title:"Что-то пошло не так",
                                              message: "Не удалось в систему ", preferredStyle: .alert)
                let action = UIAlertAction(title: "Oк", style: .default)
                alert.addAction(action)
                vc.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
            }
            
        }
    }
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
                }
    
}

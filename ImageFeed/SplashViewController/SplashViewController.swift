//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Mac on 17.08.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "showAuthenticationScreen"
    
    let service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private var screenImageView: UIImageView?
    private let storage = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAuthView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIBlockingProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            
            if self.storage.token != nil {
                guard let token = self.storage.token else {return}
                self.fetchProfile(token: token)
                           
                           
                       } else {
                           self.showViewController()
                           UIBlockingProgressHUD.dismiss()
                       }
            
        }
  }
}

         
           

    
extension SplashViewController {
    
    func createAuthView(){
        let screenImage = UIImage(named: "Vector")
        
        let screenImageView = UIImageView(image: screenImage)
        view.backgroundColor = UIColor(named: "ypBlack")
        view.addSubview(screenImageView)
        screenImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            screenImageView.widthAnchor.constraint(equalToConstant: 72),
            screenImageView.heightAnchor.constraint(equalToConstant: 76),
            screenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            screenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        self.screenImageView = screenImageView
    }
    func showViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard
            let navigationViewController = storyboard.instantiateViewController(
                withIdentifier: "NavigationController"
            ) as? UINavigationController,
            let authViewController = navigationViewController.topViewController as? AuthViewController
        else {
            print("[\(#fileID)]:[\(#function)] -> Wrong AuthView configuration")
            return
        }
        authViewController.delegate = self
        navigationViewController.modalPresentationStyle = .fullScreen
        present(navigationViewController, animated: true)
    }
}
     
     

extension SplashViewController {
    func switchToTapBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
  
    
}
extension SplashViewController: AuthViewControllerDelegate{
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
    }
    func fetchProfile(token: String) {
      UIBlockingProgressHUD.show()
        
      profileService.fetchProfile(token) {
          [weak self] result in
          UIBlockingProgressHUD.dismiss()
          guard let self = self else { return }
          switch result {
          case .success(let profile):
              ProfileImageService.shared.fetchProfileImageURL(token: token, username: profile.username) { _ in }
              self.switchToTapBarController()
          case .failure(let error):
              print(error.localizedDescription)
          }
          
   }
  
 }
    
}

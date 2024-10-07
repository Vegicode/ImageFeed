//
//  ViewControllerSpy.swift
//  ImageFeedUnitTests
//
//  Created by Mac on 07.10.2024.
//

import UIKit
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var exidButton = true
    
    func updateAvatar() { }
    
    func logout() { }
    
    func showAlert(alert: UIAlertController) { }
    
    func addSubviews() { }
    
    func addConstrains() { }
    
    func configure(_ presenter: any ImageFeed.ProfilePresenterProtocol) { }
    
    
}

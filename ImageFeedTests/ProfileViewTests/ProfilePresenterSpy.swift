//
//  PresenterSpy.swift
//  ImageFeedUnitTests
//
//  Created by Mac on 07.10.2024.
//

import ImageFeed
import UIKit

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var isButtonTapped = false
    var isViewDidLoad = false
    
    func viewDidLoad() { isViewDidLoad = true }
    
    func logout() { isButtonTapped = true }
    
    func getProfile() -> ImageFeed.Profile? { return nil }
    
    func getAvatarUrl() -> URL? { return nil }
    
}


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
    var profile: Profile?
    var isButtonTapped: Bool = false
    var isViewDidLoad: Bool = false
    
    func viewDidLoad() {
        isViewDidLoad = true
    }
    
    func logout() {
        isButtonTapped = true
        print("ProfilePresenterSpy's viewDidLoad called")
    }
    
    func getProfile() -> ImageFeed.Profile? { return nil }
    
    func getAvatarUrl() -> URL? {
        return nil
    }
    
}


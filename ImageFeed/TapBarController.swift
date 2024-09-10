//
//  TapBarController.swift
//  ImageFeed
//
//  Created by Mac on 03.09.2024.
//

import UIKit

final class TapBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
            )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
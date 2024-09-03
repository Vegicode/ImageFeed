//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Mac on 28.08.2024.
//

import Foundation


final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNitification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(){
//        NotificationCenter.default
//            .post(
//                name: ProfileService.didChangeNitification,
//                object: self,
//                userInfo: ["URL": ProfileImageURL]
//            )
    }
}

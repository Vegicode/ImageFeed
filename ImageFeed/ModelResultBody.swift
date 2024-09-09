//
//  ModelResultBody.swift
//  ImageFeed
//
//  Created by Mac on 04.09.2024.
//

import UIKit

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

//MARK: - Image

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

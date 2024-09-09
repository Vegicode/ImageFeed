//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Mac on 05.09.2024.
//

import UIKit

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

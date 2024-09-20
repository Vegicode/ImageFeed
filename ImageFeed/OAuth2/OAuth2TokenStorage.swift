//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Mac on 17.08.2024.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    let key = "Bearer Token"
    
    var token: String? {
        get{
            return KeychainWrapper.standard.string(forKey: key)
        }
        set {
            KeychainWrapper.standard.set(newValue ?? " ", forKey: key)
        }
    }
    func removeToken() {
        KeychainWrapper.standard.removeObject(forKey: key)
    }
}

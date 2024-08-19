//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Mac on 17.08.2024.
//

import Foundation

final class OAuth2Service {
    // static let shared = OAuth2Service()
    //private init() {}
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success(""))
    }
}

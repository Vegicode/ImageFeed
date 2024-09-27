//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Mac on 26.09.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standart) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        
        return URLRequest(url: url)
    }
    
    func authURL() -> URL? {
        guard var components = URLComponents(string: configuration.authURLString) else {
            print("Ошибка")
            return nil
        }
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        return components.url
    }
    
    
    
    func code(from url: URL) -> String? {
        if let components = URLComponents(string: url.absoluteString),
           components.path == "/oauth/authorize/native",
           let items = components.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
 }

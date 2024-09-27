//
//  Constants.swift
//  ImageFeed
//
//  Created by Mac on 16.08.2024.
//

import Foundation

enum Constants {
    static let accessKey = "EOk8SYOKjUreSyx5iBj-FgytiziWfqErNC4kB8_EaU0"
    static let secretKey = "vmilvFB1yBZ4y4OSPP9JGXD0Iby9nZsdTnRtqeUXP70"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

   
    
}

struct AuthConfiguration {
        let accessKey: String
        let secretKey: String
        let redirectURI: String
        let accessScope: String
        let defaultBaseURL: URL
        let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL!,
                                  authURLString: Constants.unsplashAuthorizeURLString)
    }
}

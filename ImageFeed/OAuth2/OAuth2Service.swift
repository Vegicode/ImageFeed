//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Mac on 17.08.2024.
//

import UIKit

enum AuthServiceError: Error{
    case invalidRequest
}

final class OAuth2Service {
    
    private let urlSession = URLSession.shared //1
    
    private var task: URLSessionTask? //2
    private var lastCode: String? //3
    
    static let shared = OAuth2Service()
    private init() {}

    private (set) var authToken: String {
        get {
            return OAuth2TokenStorage().token ?? ""
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    private enum JSONError: Error {
        case decodingError
    }

    struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        
        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<OAuth2Service.OAuthTokenResponseBody.CodingKeys> = try decoder.container(keyedBy: OAuth2Service.OAuthTokenResponseBody.CodingKeys.self)
            self.accessToken = try container.decode(String.self, forKey: OAuth2Service.OAuthTokenResponseBody.CodingKeys.accessToken)
            self.tokenType = try container.decode(String.self, forKey: OAuth2Service.OAuthTokenResponseBody.CodingKeys.tokenType)
        }
    }
    
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? { //18
        let baseURL = URL(string: "https://unsplash.com")
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread) //4
        guard lastCode != code else {
                completion(.failure(AuthServiceError.invalidRequest))
                return //8
            }
        
        task?.cancel()
        lastCode = code //10
        
        guard let request = makeOAuthTokenRequest(code: code) else { //11
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async { //12
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(body.accessToken))
                    self.task = nil
                    self.lastCode = nil
                case .failure(let error):
                    print("Failed to get accessToken")
                    completion(.failure(error))
                }
            }
        }
        
        self.task = task //16
        task.resume() //17
        
       
    }
}

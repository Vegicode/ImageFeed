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
    
    static let shared = OAuth2Service(networkClient: NetworkClient())
    
    private let networkClient: NetworkRouting
    private let tokenStorage = OAuth2TokenStorage()
    
    private enum JSONError: Error {
        case decodingError
    }
    private init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
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
    
    private(set) var authToken: String? {
        get{
            return tokenStorage.token
        }
        set{
            tokenStorage.token = newValue
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
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async { //12
                self?.task = nil //14
                self?.lastCode = nil //15
            }
        }
        
        self.task = task //16
        task.resume() //17
        
        networkClient.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(OAuth2Service.OAuthTokenResponseBody.self, from: data)
                    completion(.success(response.accessToken))
                    print("accessToken: \(response.accessToken) have been decoded")
                } catch {
                    completion(.failure(JSONError.decodingError))
                    print("JSON decoding error \(error.localizedDescription)")
                }
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
}

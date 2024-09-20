//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Mac on 28.08.2024.
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


enum imageError: Error {
    case invalidRequest
}


final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private var lastUsername: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    func makeImageRequest(for username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)")
        else {preconditionFailure("Error get url for image")}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let authToken = OAuth2TokenStorage().token else {
            assertionFailure("failed to get authToken")
            return nil
        }
        
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeImageRequest(for: username) else {
            completion(.failure(imageError.invalidRequest))
            return
        }
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage.medium
                
                guard let avatarURL = self.avatarURL else {
                    print("failed to get avatarURL")
                    return
                }
                
                completion(.success(avatarURL))
                self.task = nil
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL]
                    )
            case .failure(let error):
                print("failed to get avatarURL: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
       
        task?.resume()
        
    }
//         )
}


//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Mac on 28.08.2024.
//

import UIKit


enum imageError: Error {
    case invalidRequest
}


final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private var lastUsername: String?
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    func makeImageRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)")
        else {preconditionFailure("Error get url for image")}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        
        guard lastUsername != username else{
            completion(.failure(imageError.invalidRequest))
            return
        }
        task?.cancel()
        
        lastUsername = username
        guard let request = makeImageRequest(token: token, username: username) else{
            completion(.failure(imageError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request){ [weak self] (result: Result<UserResult,Error>) in
            DispatchQueue.main.async {
                    switch result{
                    case .success(let avatar):
                        let avatarUrl = avatar.profileImage.large
                        self?.avatarURL = avatarUrl
                        completion(.success(avatarUrl))
                    case .failure(let error):
                        completion(.failure(error))
                        print("[ProfileImageService.fetchProfileImage]: NetworkError - \(error.localizedDescription) for userID: \(username)")
                    }
                }
                self?.lastUsername = nil
                self?.task = nil
            }
            task.resume()
        }
//         )
}


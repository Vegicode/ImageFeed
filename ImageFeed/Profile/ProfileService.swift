//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Mac on 27.08.2024.
//

import UIKit

enum ProfileServiceError: Error {
    case profileNotFound
}


struct ProfileResult: Codable {
    var username: String
    var firstName: String
    var lastName: String?
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

public struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    //let bio = ProfileResult.init()
    
    init(result: ProfileResult) {
        self.username = result.username
        self.name = "\(result.firstName)" + "\(result.lastName ?? "")"
        self.loginName = "@\(result.username)"
        self.bio = result.bio ?? ""
       }

    
}



final class ProfileService {
    
    
    static let shared = ProfileService()
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    private init() { }
    private func makeURLRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
        
    }
    
    func fetchProfile(_ token: String, completion:@escaping (Result<Profile, Error>) -> Void){
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeURLRequest(token: token) else {
            completion(.failure(ProfileServiceError.profileNotFound))
            return
            
        }
        
        task = urlSession.objectTask(for: request)
        { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                self.profile = Profile(result: result)
                guard let profileData = self.profile else {
                    print("Error: profileData")
                    return
                }
                completion(.success(profileData))
                self.task = nil
                
            case .failure(let error):
                print("failed to get profileData:\(error.localizedDescription)")
                completion(.failure(error))
                
            }
            
            
            
        }
        task?.resume()
    }

}

//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Mac on 27.08.2024.
//

import Foundation

enum ProfileServiceError: Error {
    case profileNotFound
}

private enum JSONError: Error {
    case decodingError
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
        case bio = "bio"
        
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    //let bio = ProfileResult.init()
    
    init(result: ProfileResult) {
        self.username = result.username
        self.name = ("\(result.firstName) \(result.lastName ?? "")")
        self.loginName = ("@\(result.username)")
        self.bio = result.bio ?? ""
    }

    
}



final class ProfileService {
    
    
    private init() { }
    private var task: URLSessionTask?
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var networkClient: NetworkClient
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
                print("Make URLRequest error")
                return
            }
            networkClient.data(for: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(ProfileResult.self, from: data)
                        self.profile = Profile(result: result)
                        print("profile was decoded")
                        
                        if let profile = self.profile {
                            completion(.success(profile))
                            print("success")
                        }else{
                            completion(.failure(ProfileServiceError.profileNotFound))
                            print("fail")
                            
                        }
                    } catch {
                        completion(.failure(JSONError.decodingError))
                        print("JSON decoding error \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("FetchProfile - \(error)")
                    completion(.failure(error))
                }
            }
        }
    
}

//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Mac on 04.09.2024.
//

import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        complition: @escaping (Result<T,Error>) -> Void
    ) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        return data(for: request ) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<T, Error> in
                Result {
                    do {
                        return try decoder.decode(T.self, from: data)
                    } catch {
                        print("failed data decoding")
                        throw error
                    }
                }
            }
            complition(response)
        }
    }
    
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                    print("Success Status: \(statusCode)")
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    print("Status: \(statusCode)")
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                print(error.localizedDescription)
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                print(error?.localizedDescription as Any)
            }
        })
        
        return task
    }
}



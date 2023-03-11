//
//  RocketNetworkService.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 07.03.2023.
//

import Foundation

protocol RocketInfoProviding {
    func getRockets(completion: @escaping (Result<[RocketModel], APIError>) -> Void)
    func getLaunches(completion: @escaping (Result<[LaunchModel], APIError>) -> Void)
}

final class RocketNetworkService: RocketInfoProviding {
    
    private enum APIurl: String {
        case rockets = "https://api.spacexdata.com/v4/rockets"
        case launches = "https://api.spacexdata.com/v4/launches"
    }
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared,
         jsonDecoder: JSONDecoder = .init(),
         keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = keyDecodingStrategy
    }
    
    // MARK: - Public Methods
    
    public func getRockets(completion: @escaping (Result<[RocketModel], APIError>) -> Void) {
        request(link: .rockets,
                expecting: [RocketModel].self,
                completion: completion)
    }
    
    public func getLaunches(completion: @escaping (Result<[LaunchModel], APIError>) -> Void) {
        request(link: .launches,
                expecting: [LaunchModel].self,
                completion: completion)
    }
    
    // MARK: - Private Methods
    
    private func request<T: Codable>(link: APIurl,
                                     expecting: T.Type,
                                     completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: link.rawValue) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        urlSession.dataTask(with: URLRequest(url: url)) { [jsonDecoder] data, _, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let result = try jsonDecoder.decode(expecting.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(APIError.decodingError))
                }
            case (nil, .some(_)):
                completion(.failure(APIError.unknownError))
            default:
                completion(.failure(APIError.invalidState))
            }
        }
        .resume()
    }
}

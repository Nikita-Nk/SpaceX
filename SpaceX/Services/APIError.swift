//
//  APIError.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 07.03.2023.
//

import Foundation

enum APIError: Error {
    case noInternetConnection
    case invalidURL
    case invalidState
    case unknownError
    case decodingError
    
    var description: String {
        switch self {
        case .noInternetConnection:
            return "No internet connection. Failed to load data"
        default:
            return "Failed to load data"
        }
    }
}

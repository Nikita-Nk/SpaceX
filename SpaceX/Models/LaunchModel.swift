//
//  LaunchModel.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 07.03.2023.
//

import Foundation

struct LaunchModel: Codable {
    let rocket: String
    let success: Bool?
    let details: String?
    let payloads: [String]
    let flightNumber: Int
    let name: String
    let dateUtc: String
    let dateLocal: String
    let upcoming: Bool
    let id: String
    
    var dateFormatted: String {
        dateUtc.formatDate(formatIn: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", formatOut: "MMMM d, YYYY")
    }
}

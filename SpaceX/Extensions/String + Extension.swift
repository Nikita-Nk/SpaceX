//
//  String + Extension.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 10.03.2023.
//

import Foundation

extension String {
    
    func formatDate(formatIn: String, formatOut: String) -> String {
        let dateInFormatter = DateFormatter()
        dateInFormatter.dateFormat = formatIn
        let dateOutFormatter = DateFormatter()
        dateOutFormatter.locale = .init(identifier: "en")
        dateOutFormatter.dateFormat = formatOut
        
        guard let date = dateInFormatter.date(from: self) else { return "" }
        return dateOutFormatter.string(from: date)
    }
}

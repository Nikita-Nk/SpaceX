//
//  Double + Extension.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 11.03.2023.
//

import Foundation

extension Double {
    
    func toString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.decimalSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "-"
    }
}

extension Double? {
    
    func toString() -> String {
        if let value = self {
            return value.toString()
        } else {
            return "-"
        }
    }
}

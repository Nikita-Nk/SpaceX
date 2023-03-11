//
//  Int + Extension.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 11.03.2023.
//

import Foundation

extension Int {
    
    func toString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "-"
    }
    
    func priceToString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.currencySymbol = "$"
        formatter.locale = .init(identifier: "en")
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "-"
    }
}

extension Int? {
    
    func toString() -> String {
        if let value = self {
            return value.toString()
        } else {
            return "-"
        }
    }
}

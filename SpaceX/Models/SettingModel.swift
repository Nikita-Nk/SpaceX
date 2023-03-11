//
//  SettingModel.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 07.03.2023.
//

import Foundation

struct SettingModel: Codable {
    let type: SettingType
    var selectedIndex: Int
    
    var selectedUnit: Unit {
        type.units[selectedIndex]
    }
}

enum SettingType: Codable {
    case height
    case diameter
    case mass
    case payload
    
    var name: String {
        switch self {
        case .height:
            return "Height"
        case .diameter:
            return "Diameter"
        case .mass:
            return "Mass"
        case .payload:
            return "Payload"
        }
    }
    
    var units: [Unit] {
        switch self {
        case .height, .diameter:
            return [.meter, .feet]
        case .mass, .payload:
            return [.kilogram, .pound]
        }
    }
}

enum Unit: Codable {
    case meter
    case feet
    case kilogram
    case pound
    
    var name: String {
        switch self {
        case .meter:
            return "m"
        case .feet:
            return "ft"
        case .kilogram:
            return "kg"
        case .pound:
            return "lb"
        }
    }
}

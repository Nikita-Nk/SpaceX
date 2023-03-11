//
//  RocketModel.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 07.03.2023.
//

import Foundation

struct RocketModel: Codable {
    typealias Height = Diameter
    
    let height: Height
    let diameter: Diameter
    let mass: Mass
    let firstStage: Stage
    let secondStage: Stage
    let payloadWeights: [Mass]
    let name: String
    let costPerLaunch: Int
    let firstFlight: String
    let country: String
    let company: String
    let id: String
}

// MARK: - Nested Types

extension RocketModel {
    
    struct Diameter: Codable {
        let meters: Double?
        let feet: Double?
        
        func getValue(unit: Unit) -> Double? {
            switch unit {
            case .meter:
                return meters
            case .feet:
                return feet
            default:
                return nil
            }
        }
    }
    
    struct Mass: Codable {
        let kg: Int
        let lb: Int
        
        func getValue(unit: Unit) -> Int? {
            switch unit {
            case .kilogram:
                return kg
            case .pound:
                return lb
            default:
                return nil
            }
        }
    }
    
    struct Stage: Codable {
        let engines: Int
        let fuelAmountTons: Double
        let burnTimeSec: Int?
    }
}

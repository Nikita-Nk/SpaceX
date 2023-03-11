//
//  RocketSection.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 07.03.2023.
//

import UIKit

enum RocketSection {
    case header(HeaderModel)
    case measurement([MeasurementModel])
    case info(title: String?, [InfoModel])
    case button([ButtonModel])
    
    var count: Int {
        switch self {
        case .header:
            return 1
        case .measurement(let models):
            return models.count
        case .info(_, let models):
            return models.count
        case .button(let models):
            return models.count
        }
    }
}

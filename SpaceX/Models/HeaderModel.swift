//
//  HeaderModel.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 07.03.2023.
//

import Foundation

struct HeaderModel {
    let imageLink: String
    let rocketName: String
    let handler: (() -> Void)
}

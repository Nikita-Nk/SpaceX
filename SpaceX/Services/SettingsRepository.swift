//
//  SettingsRepository.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 07.03.2023.
//

import Foundation

protocol SettingsRepositoryProtocol {
    func save(_ settings: [SettingModel])
    func fetch() -> [SettingModel]
}

final class SettingsRepository: SettingsRepositoryProtocol {
    
    private enum Key {
        static let settings = "settings"
    }
    
    private let userDefaults: UserDefaults
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder
    
    init(userDefaults: UserDefaults = .standard,
         jsonDecoder: JSONDecoder = .init(),
         jsonEncoder: JSONEncoder = .init()) {
        self.userDefaults = userDefaults
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
    }
    
    // MARK: - Public Methods
    
    public func save(_ settings: [SettingModel]) {
        guard let data = try? jsonEncoder.encode(settings) else { return }
        userDefaults.set(data, forKey: Key.settings)
    }
    
    public func fetch() -> [SettingModel] {
        guard let data = userDefaults.data(forKey: Key.settings),
              let settings = try? jsonDecoder.decode([SettingModel].self, from: data) else {
            return createSettings()
        }
        return settings
    }
    
    // MARK: - Private Methods
    
    private func createSettings() -> [SettingModel] {
        let settings: [SettingModel] = [.init(type: .height, selectedIndex: 0),
                                        .init(type: .diameter, selectedIndex: 0),
                                        .init(type: .mass, selectedIndex: 0),
                                        .init(type: .payload, selectedIndex: 0)]
        save(settings)
        return settings
    }
}

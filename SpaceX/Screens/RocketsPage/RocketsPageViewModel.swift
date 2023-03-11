//
//  RocketsPageViewModel.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 07.03.2023.
//

import UIKit

protocol RocketsPageViewModelOutput: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func failedToLoadData(error: APIError)
}

final class RocketsPageViewModel {
    
    public weak var output: RocketsPageViewModelOutput?
    
    public let initialPage = 0
    private (set) var pages = [RocketViewContoller]()
    
    private let networkService: RocketNetworkService
    
    // MARK: - Init
    
    init(networkService: RocketNetworkService) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    public func fetchData() {
        output?.didStartLoading()
        var rockets = [RocketModel]()
        var launches = [LaunchModel]()
        var apiError: APIError?
        let group = DispatchGroup()
        
        group.enter()
        networkService.getRockets { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let result):
                rockets = result
            case .failure(let error):
                apiError = error
            }
        }
        
        group.enter()
        networkService.getLaunches { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let result):
                launches = result
            case .failure(let error):
                apiError = error
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            if let apiError = apiError {
                self?.output?.failedToLoadData(error: apiError)
            } else {
                self?.preparePage(rockets: rockets, launches: launches)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func preparePage(rockets: [RocketModel], launches: [LaunchModel]) {
        for rocket in rockets {
            let relevantLaunches = launches.reversed().filter({ $0.rocket == rocket.id })
            let rocketVC = RocketViewContoller()
            let settingsRepository = SettingsRepository()
            let viewModel = RocketViewModel(rocket: rocket,
                                            launches: relevantLaunches,
                                            rocketVC: rocketVC,
                                            settingsRepository: settingsRepository)
            rocketVC.configure(with: viewModel)
            pages.append(rocketVC)
        }
        output?.didFinishLoading()
    }
}

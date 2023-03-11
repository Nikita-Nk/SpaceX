//
//  RocketViewModel.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 08.03.2023.
//

import UIKit

protocol RocketViewModelOutput: AnyObject {
    func didUpdateMeasurementSection()
}

final class RocketViewModel {
    
    public weak var output: RocketViewModelOutput?
    
    public var sections: [RocketSection] {
        [mainHeader, measurement, info, infoFirstStage, infoSecondStage, buttons]
    }
    
    private let mainHeader: RocketSection
    private var measurement: RocketSection
    private let info: RocketSection
    private let infoFirstStage: RocketSection
    private let infoSecondStage: RocketSection
    private let buttons: RocketSection
    
    private weak var rocketVC: UIViewController?
    private let settingsRepository: SettingsRepository
    private let rocketModel: RocketModel
    
    // MARK: - Init
    
    init(rocket: RocketModel,
         launches: [LaunchModel],
         rocketVC: UIViewController,
         settingsRepository: SettingsRepository) {
        self.rocketModel = rocket
        self.rocketVC = rocketVC
        self.settingsRepository = settingsRepository
        
        mainHeader = RocketViewModel.getHeaderSection(rocket: rocket, rocketVC: rocketVC)
        measurement = RocketViewModel.getMeasurementSection(rocket: rocket,
                                                            settingsRepository: settingsRepository)
        info = RocketViewModel.getInfoSection(rocket: rocket)
        infoFirstStage = RocketViewModel.getInfoFirstStage(rocket: rocket)
        infoSecondStage = RocketViewModel.getInfoSecondStage(rocket: rocket)
        let launchesModel = LaunchesModel(title: rocket.name, launches: launches)
        buttons = RocketViewModel.getButtonSection(rocketVC: rocketVC, launchesModel: launchesModel)
    }
    
    // MARK: - Public Methods
    
    public func updateMeasurementSection() {
        measurement = RocketViewModel.getMeasurementSection(rocket: rocketModel,
                                                            settingsRepository: settingsRepository)
        output?.didUpdateMeasurementSection()
    }
    
    // MARK: - Private Methods
    
    private static func getHeaderSection(rocket: RocketModel, rocketVC: UIViewController) -> RocketSection {
        let imageLink = RocketViewModel.getImageLink(rocketName: rocket.name)
        let mainHeader = HeaderModel(imageLink: imageLink,
                                     rocketName: rocket.name,
                                     handler: {
            let settingsRepository = SettingsRepository()
            let settingsVC = SettingsViewController(settingsRepository: settingsRepository)
            settingsVC.delegate = rocketVC as? SettingsViewControllerDelegate
            let navController = UINavigationController(rootViewController: settingsVC)
            navController.modalPresentationStyle = .pageSheet
            rocketVC.present(navController, animated: true)
        })
        return RocketSection.header(mainHeader)
    }
    
    private static func getMeasurementSection(rocket: RocketModel,
                                              settingsRepository: SettingsRepository) -> RocketSection {
        let settings = settingsRepository.fetch()
        var models = [MeasurementModel]()
        var value = ""
        
        for setting in settings {
            switch setting.type {
            case .height:
                let unit = SettingType.height.units[setting.selectedIndex]
                value = rocket.height.getValue(unit: unit).toString()
            case .diameter:
                let unit = SettingType.diameter.units[setting.selectedIndex]
                value = rocket.diameter.getValue(unit: unit).toString()
            case .mass:
                let unit = SettingType.mass.units[setting.selectedIndex]
                value = rocket.mass.getValue(unit: unit).toString()
            case .payload:
                let unit = SettingType.payload.units[setting.selectedIndex]
                value = rocket.payloadWeights.map({ $0.getValue(unit: unit) ?? 0 }).reduce(0, +).toString()
            }
            
            models.append(.init(title: setting.type.name,
                                value: value,
                                unit: setting.type.units[setting.selectedIndex].name))
        }
        
        return .measurement(models)
    }
    
    private static func getInfoSection(rocket: RocketModel) -> RocketSection {
        .info(title: nil, [
            .init(title: "First launch",
                  value: rocket.firstFlight.formatDate(formatIn: "yyyy-MM-dd",
                                                       formatOut: "MMMM d, YYYY"),
                  unit: nil),
            .init(title: "Country", value: rocket.country, unit: nil),
            .init(title: "Launch cost", value: rocket.costPerLaunch.priceToString(), unit: nil)])
    }
    
    private static func getInfoFirstStage(rocket: RocketModel) -> RocketSection {
        .info(title: "First stage", [
            .init(title: "Engines", value: "\(rocket.firstStage.engines)", unit: ""),
            .init(title: "Fuel amount", value: rocket.firstStage.fuelAmountTons.toString(), unit: "ton"),
            .init(title: "Burn time", value: rocket.firstStage.burnTimeSec.toString(), unit: "sec")])
    }
    
    private static func getInfoSecondStage(rocket: RocketModel) -> RocketSection {
        .info(title: "Second stage", [
            .init(title: "Engines", value: "\(rocket.secondStage.engines)", unit: ""),
            .init(title: "Fuel amount", value: rocket.secondStage.fuelAmountTons.toString(), unit: "ton"),
            .init(title: "Burn time", value: rocket.secondStage.burnTimeSec.toString(), unit: "sec")])
    }
    
    private static func getButtonSection(rocketVC: UIViewController, launchesModel: LaunchesModel) -> RocketSection {
        .button([.init(buttonTitle: "View launches",
                       textColor: .label,
                       buttonColor: .tertiarySystemBackground,
                       handler: {
            let launchesVC = LaunchesViewController()
            launchesVC.configure(with: launchesModel)
            rocketVC.navigationController?.pushViewController(launchesVC, animated: true)
        })])
    }
    
    private static func getImageLink(rocketName: String) -> String {
        switch rocketName {
        case "Falcon 1":
            return "https://upload.wikimedia.org/wikipedia/commons/d/d4/Falcon_1_Flight_5_rises_over_Omelek_Island.jpg"
        case "Falcon 9":
            return "https://www.ixbt.com/img/n1/news/2022/8/1/falcon-9_large.jpg"
        case "Falcon Heavy":
            return "https://i.imgur.com/l5U6apv.jpg"
        case "Starship":
            return "https://cdn.forbes.ru/forbes-static/750x422/new/2022/03/1-SpaceX-Starship-623999644030b.jpg"
        default:
            return "https://devby.io/storage/images/11/04/01/14/derived/67dcfaf4c08bd41a323780488b7a8638.jpg"
        }
    }
}

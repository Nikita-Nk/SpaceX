//
//  SettingsViewController.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 08.03.2023.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func didChangeSettings()
}

final class SettingsViewController: UIViewController {
    
    public weak var delegate: SettingsViewControllerDelegate?
    
    private let settingsRepository: SettingsRepositoryProtocol
    
    private var settings: [SettingModel]
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        table.separatorStyle = .none
        table.allowsSelection = false
        table.bounces = false
        table.backgroundColor = .black
        table.register(SettingTableViewCell.self,
                       forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.dataSource = self
        return table
    }()
    
    // MARK: - Init
    
    init(settingsRepository: SettingsRepositoryProtocol) {
        self.settingsRepository = settingsRepository
        settings = settingsRepository.fetch()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.addSubview(tableView)
        setupConstraints()
        setupNavBar()
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    @objc private func didTapCloseButton(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settings[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier,
                                                       for: indexPath) as? SettingTableViewCell else {
            return SettingTableViewCell()
        }
        
        cell.delegate = self
        cell.configure(with: setting)
        return cell
    }
}

// MARK: - SettingTableViewCellDelegate

extension SettingsViewController: SettingTableViewCellDelegate {
    
    func didChangeSetting(_ setting: SettingModel) {
        guard let settingIndex = settings.firstIndex(where: { $0.type == setting.type }) else {
            return
        }
        settings[settingIndex] = setting
        settingsRepository.save(settings)
        delegate?.didChangeSettings()
    }
}

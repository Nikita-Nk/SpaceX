//
//  LaunchesViewController.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 08.03.2023.
//

import UIKit

final class LaunchesViewController: UIViewController {
    
    private var launches = [LaunchModel]()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        table.separatorStyle = .none
        table.allowsSelection = false
        table.bounces = false
        table.backgroundColor = .systemBackground
        table.register(LaunchTableViewCell.self,
                       forCellReuseIdentifier: LaunchTableViewCell.identifier)
        table.dataSource = self
        return table
    }()
    
    private lazy var noLaunchesLabel: UILabel = {
        let label = UILabel()
        label.text = "No information about launches"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        [tableView, noLaunchesLabel].forEach({ view.addSubview($0) })
        setupConstraints()
    }
    
    // MARK: - Public Methods
    
    public func configure(with model: LaunchesModel) {
        launches = model.launches
        title = model.title
        tableView.isHidden = launches.count == 0
        noLaunchesLabel.isHidden = launches.count != 0
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        noLaunchesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            noLaunchesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            noLaunchesLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            noLaunchesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            noLaunchesLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }
}

// MARK: - UITableViewDataSource

extension LaunchesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LaunchTableViewCell.identifier,
            for: indexPath) as? LaunchTableViewCell else { return UITableViewCell() }
        let launch = launches[indexPath.row]
        cell.configure(with: launch)
        return cell
    }
}

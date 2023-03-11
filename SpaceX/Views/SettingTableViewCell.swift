//
//  SettingTableViewCell.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 08.03.2023.
//

import UIKit

protocol SettingTableViewCellDelegate: AnyObject {
    func didChangeSetting(_ setting: SettingModel)
}

final class SettingTableViewCell: UITableViewCell {
    
    static let identifier = "SettingTableViewCell"
    
    public weak var delegate: SettingTableViewCellDelegate?
    
    private var setting: SettingModel?
    
    private lazy var settingNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var unitSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.selectedSegmentTintColor = .label
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let normalColor = UIColor.secondaryLabel
        let selectedColor = UIColor.systemBackground
        control.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: normalColor],
                                       for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor],
                                       for: .selected)
        control.addTarget(self, action: #selector(didChangeSetting(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [settingNameLabel, unitSegmentedControl])
        stack.spacing = 15
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        contentView.addSubview(horizontalStackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func configure(with setting: SettingModel) {
        self.setting = setting
        settingNameLabel.text = setting.type.name
        for (index, unit) in setting.type.units.enumerated() {
            unitSegmentedControl.insertSegment(withTitle: unit.name, at: index, animated: false)
        }
        unitSegmentedControl.selectedSegmentIndex = setting.selectedIndex
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        unitSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            unitSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            unitSegmentedControl.widthAnchor.constraint(equalToConstant: 130),
            
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            horizontalStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            horizontalStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
    }
    
    @objc private func didChangeSetting(_ segmentedControl: UISegmentedControl) {
        setting?.selectedIndex = segmentedControl.selectedSegmentIndex
        guard let setting = setting else { return }
        delegate?.didChangeSetting(setting)
    }
}

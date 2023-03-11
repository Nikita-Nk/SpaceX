//
//  MeasurementCollectionViewCell.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 08.03.2023.
//

import UIKit

final class MeasurementCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MeasurementCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stack.spacing = 5
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func configure(with model: MeasurementModel) {
        titleLabel.text = model.title + ", " + model.unit
        valueLabel.text = model.value
    }
    
    // MARK: - Private Methods
    
    private func prepareViews() {
        contentView.clipsToBounds = true
        contentView.addSubview(labelsStackView)
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 35
    }
    
    private func setupConstraints() {
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelsStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            labelsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelsStackView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 0.5),
            labelsStackView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.9)
        ])
    }
}

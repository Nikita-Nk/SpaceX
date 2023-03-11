//
//  InfoCollectionViewCell.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 08.03.2023.
//

import UIKit

final class InfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "InfoCollectionViewCell"
    
    private let fontSize: CGFloat = 16
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: fontSize, weight: .regular)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .label
        label.font = .systemFont(ofSize: fontSize, weight: .bold)
        return label
    }()
    
    private lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: fontSize, weight: .bold)
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel, unitLabel])
        stack.spacing = 10
        stack.axis = .horizontal
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        addSubview(labelsStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func configure(with model: InfoModel) {
        titleLabel.text = model.title
        valueLabel.text = model.value
        unitLabel.text = model.unit
        
        unitLabel.isHidden = unitLabel.text == nil
        if model.unit == nil {
            valueLabel.font = .systemFont(ofSize: fontSize, weight: .regular)
        } else {
            valueLabel.font = .systemFont(ofSize: fontSize, weight: .bold)
        }
        
        setupConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: self.topAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            unitLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            unitLabel.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}

//
//  ButtonCollectionViewCell.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 08.03.2023.
//

import UIKit

final class ButtonCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ButtonCollectionViewCell"
    
    private var model: ButtonModel?
    
    private lazy var customButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(customButton)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func configure(with model: ButtonModel) {
        self.model = model
        customButton.backgroundColor = model.buttonColor
        customButton.setTitle(model.buttonTitle, for: .normal)
        customButton.setTitleColor(model.textColor, for: .normal)
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        customButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            customButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func didTapButton() {
        model?.handler()
    }
}

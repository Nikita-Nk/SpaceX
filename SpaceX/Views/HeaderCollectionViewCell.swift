//
//  HeaderCollectionViewCell.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 08.03.2023.
//

import UIKit

final class HeaderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HeaderCollectionViewCell"
    
    private var model: HeaderModel?
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .label
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    private lazy var rocketNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .secondaryLabel
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 28), forImageIn: .normal)
        button.addTarget(self, action: #selector(didTapSettingsButton(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageView, baseView, rocketNameLabel, settingsButton].forEach { addSubview($0) }
        clipsToBounds = true
        backgroundColor = .systemBackground
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func configure(model: HeaderModel) {
        self.model = model
        rocketNameLabel.text = model.rocketName
        guard let imageURL = URL(string: model.imageLink) else { return }
        ImageLoader.shared.image(for: imageURL) { image in
            self.imageView.image = image
        }
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        rocketNameLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 500),
            
            baseView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 4),
            baseView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -2),
            baseView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 4),
            baseView.heightAnchor.constraint(equalTo: rocketNameLabel.heightAnchor, multiplier: 2.4),
            
            rocketNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rocketNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            rocketNameLabel.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -30),
            
            settingsButton.centerYAnchor.constraint(equalTo: rocketNameLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])
    }
    
    @objc private func didTapSettingsButton(_: UIButton) {
        model?.handler()
    }
}

//
//  LaunchTableViewCell.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 08.03.2023.
//

import UIKit

final class LaunchTableViewCell: UITableViewCell {
    
    static let identifier = "LaunchTableViewCell"
    
    private let successLabelHeight: CGFloat = 15
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var rocketView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rocket")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.layer.cornerRadius = successLabelHeight / 2
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        stack.spacing = 5
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [verticalStackView, rocketView])
        stack.spacing = 15
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(containerView)
        containerView.addSubview(horizontalStackView)
        rocketView.addSubview(successLabel)
        setupConstraints()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func configure(with launch: LaunchModel) {
        nameLabel.text = launch.name
        dateLabel.text = launch.dateFormatted
        
        guard let success = launch.success else {
            successLabel.text = ""
            successLabel.backgroundColor = .clear
            return
        }
        
        if success {
            successLabel.text = "✓"
            successLabel.backgroundColor = .systemGreen
        } else {
            successLabel.text = "×"
            successLabel.backgroundColor = .systemRed
            
            guard let rocketImage = UIImage(named: "Rocket")?.cgImage else { return }
            let flippedImage = UIImage(cgImage: rocketImage, scale: 1.0, orientation: .down)
            rocketView.image = flippedImage
        }
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        rocketView.translatesAutoresizingMaskIntoConstraints = false
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            horizontalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28),
            horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -28),
            horizontalStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 28),
            horizontalStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -28),
            
            rocketView.heightAnchor.constraint(equalToConstant: 35),
            rocketView.widthAnchor.constraint(equalToConstant: 35),
            
            successLabel.rightAnchor.constraint(equalTo: rocketView.rightAnchor),
            successLabel.bottomAnchor.constraint(equalTo: rocketView.bottomAnchor),
            successLabel.widthAnchor.constraint(equalToConstant: successLabelHeight),
            successLabel.heightAnchor.constraint(equalToConstant: successLabelHeight)
        ])
    }
}

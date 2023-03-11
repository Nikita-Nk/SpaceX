//
//  RocketViewContoller.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 08.03.2023.
//

import UIKit

final class RocketViewContoller: UIViewController {
    
    private (set) var viewModel: RocketViewModel?
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.bounces = false
        collectionView.register(InfoHeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: InfoHeaderSupplementaryView.identifier)
        collectionView.register(HeaderCollectionViewCell.self,
                                forCellWithReuseIdentifier: HeaderCollectionViewCell.identifier)
        collectionView.register(MeasurementCollectionViewCell.self,
                                forCellWithReuseIdentifier: MeasurementCollectionViewCell.identifier)
        collectionView.register(InfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)
        collectionView.register(ButtonCollectionViewCell.self,
                                forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.updateMeasurementSection()
    }
    
    // MARK: - Public Methods
    
    public func configure(with viewModel: RocketViewModel) {
        self.viewModel = viewModel
        self.viewModel?.output = self
    }
    
    // MARK: - Private Methods
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionNumber, _ in
            let sections = self.viewModel?.sections ?? []
            let section = sections[sectionNumber]
            
            switch section {
            case .header:
                return self.createVerticalSection(contentInsets: .zero, shouldAddHeader: false)
            case .measurement:
                return self.createHorizontalSection()
            case .info(let title, _):
                let contentInset = NSDirectionalEdgeInsets.init(top: 0, leading: 30, bottom: 45, trailing: 30)
                return self.createVerticalSection(contentInsets: contentInset, shouldAddHeader: title != nil)
            case .button:
                let contentInset = NSDirectionalEdgeInsets.init(top: 0, leading: 30, bottom: 80, trailing: 30)
                return self.createVerticalSection(contentInsets: contentInset, shouldAddHeader: false)
            }
        }, configuration: configuration)
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(105),
                                               heightDimension: .absolute(105))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 30, leading: 30, bottom: 40, trailing: 30)
        section.interGroupSpacing = 15
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func createVerticalSection(contentInsets: NSDirectionalEdgeInsets,
                                       shouldAddHeader: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        section.interGroupSpacing = 25
        
        if shouldAddHeader {
            section.supplementariesFollowContentInsets = true
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(30))
            section.boundarySupplementaryItems = [.init(layoutSize: headerSize,
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top,
                                                        absoluteOffset: CGPoint(x: 0, y: -22))]
        }
        
        return section
    }
}

// MARK: - RocketViewModelOutput

extension RocketViewContoller: RocketViewModelOutput {
    
    func didUpdateMeasurementSection() {
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                let indexSet = IndexSet(integer: 1)
                self.collectionView.reloadSections(indexSet)
            }
        }
    }
}

// MARK: - SettingsViewControllerDelegate

extension RocketViewContoller: SettingsViewControllerDelegate {
    
    func didChangeSettings() {
        viewModel?.updateMeasurementSection()
    }
}

// MARK: - UICollectionViewDataSource

extension RocketViewContoller: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch viewModel?.sections[indexPath.section] {
        case .info(let title, _):
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: InfoHeaderSupplementaryView.identifier,
                for: indexPath) as? InfoHeaderSupplementaryView else { return UICollectionReusableView() }
            header.configure(with: title)
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.sections[section].count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel?.sections[indexPath.section] {
        case .header(let model):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HeaderCollectionViewCell.identifier,
                for: indexPath) as? HeaderCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(model: model)
            return cell
        case .measurement(let models):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MeasurementCollectionViewCell.identifier,
                for: indexPath) as? MeasurementCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: models[indexPath.row])
            return cell
        case .info(_, let models):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: InfoCollectionViewCell.identifier,
                for: indexPath) as? InfoCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: models[indexPath.row])
            return cell
        case .button(let models):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ButtonCollectionViewCell.identifier,
                for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: models[indexPath.row])
            return cell
        case .none:
            return UICollectionViewCell()
        }
    }
}

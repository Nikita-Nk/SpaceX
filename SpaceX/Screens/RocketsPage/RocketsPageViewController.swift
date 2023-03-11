//
//  RocketsPageViewController.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 06.03.2023.
//

import UIKit

final class RocketsPageViewController: UIPageViewController {
    
    private let viewModel: RocketsPageViewModel
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .label
        control.pageIndicatorTintColor = .systemGray2
        control.currentPage = viewModel.initialPage
        control.addTarget(self, action: #selector(didTapPageControl(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .label
        indicator.backgroundColor = .systemBackground
        return indicator
    }()
    
    // MARK: - Init
    
    init(viewModel: RocketsPageViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal)
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        viewModel.fetchData()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(pageControl)
        view.addSubview(activityIndicator)
        self.dataSource = self
        self.delegate = self
    }
    
    private func setupConstraints() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func didTapPageControl(_ sender: UIPageControl) {
        setViewControllers([viewModel.pages[sender.currentPage]], direction: .reverse, animated: false)
    }
}

// MARK: - RocketsPageViewModelOutput

extension RocketsPageViewController: RocketsPageViewModelOutput {
    
    func didStartLoading() {
        activityIndicator.startAnimating()
    }
    
    func didFinishLoading() {
        activityIndicator.stopAnimating()
        pageControl.numberOfPages = viewModel.pages.count
        setViewControllers([viewModel.pages[viewModel.initialPage]], direction: .forward, animated: true)
    }
    
    func failedToLoadData(error: APIError) {
        activityIndicator.stopAnimating()
        
        let alert = UIAlertController(title: nil,
                                      message: error.description,
                                      preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
            self?.viewModel.fetchData()
        }
        
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDelegate

extension RocketsPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers as? [RocketViewContoller],
              let currentIndex = viewModel.pages.firstIndex(of: viewControllers[0]) else { return }
        pageControl.currentPage = currentIndex
    }
}

// MARK: - UIPageViewControllerDataSource

extension RocketsPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let rocketVC = viewController as? RocketViewContoller,
              let currentIndex = viewModel.pages.firstIndex(of: rocketVC) else { return nil }
        return currentIndex == 0 ? viewModel.pages.last : viewModel.pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let rocketVC = viewController as? RocketViewContoller,
              let currentIndex = viewModel.pages.firstIndex(of: rocketVC) else { return nil }
        return currentIndex < viewModel.pages.count - 1 ? viewModel.pages[currentIndex + 1] : viewModel.pages.first
    }
}

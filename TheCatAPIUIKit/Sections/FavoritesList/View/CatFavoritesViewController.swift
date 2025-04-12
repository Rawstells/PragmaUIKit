//
//  CatFavoritesViewController.swift
//  TheCatAPIUIKit
//
//  Created by joan on 06/04/25.
//

import UIKit

class CatFavoritesViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = CatFavoritesViewModel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CatFavoriteCell.self, forCellWithReuseIdentifier: "CatFavoriteCell")
        return collectionView
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Favoritos"
        view.backgroundColor = .systemGroupedBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onFavoritesLoaded = { [weak self] in
            self?.collectionView.reloadData()
            self?.updateEmptyState()
        }
        
        viewModel.onLoadingStateChanged = { [weak self] in
            if self?.viewModel.isLoading == true {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                
                self?.cancelLoadingIfNeeded()
            }
        }
        
        viewModel.onErrorOccurred = { [weak self] errorMessage in
            self?.showAlert(title: "Error", message: errorMessage)
            self?.updateEmptyState()
        }
    }
    
    private func updateEmptyState() {
        if viewModel.favorites.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
    
    private func showEmptyState() {
        let emptyStateView = EmptyStateView()
        emptyStateView.onButtonTap = { [weak self] in
            self?.tabBarController?.selectedIndex = 0
        }
        collectionView.backgroundView = emptyStateView
    }
    
    private func hideEmptyState() {
        collectionView.backgroundView = nil
    }
    
    private func cancelLoadingIfNeeded() {
        let loadingTimeout: TimeInterval = 10
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingTimeout) { [weak self] in
            guard let self = self, self.viewModel.isLoading else { return }
            
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.viewModel.cancelLoading()
            self.showAlert(title: "Error", message: "Tiempo de espera agotado. Revisa tu conexión.")
            self.updateEmptyState()
        }
    }
    
    @objc private func handleRefresh() {
        viewModel.loadFavorites()
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func removeFavorite(_ sender: UIButton) {
        let favoriteId = viewModel.favorites[sender.tag].breedId
        
        animateButton(sender)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        viewModel.removeFavorite(breedId: favoriteId) { [weak self] success in
            if !success {
                self?.showAlert(title: "Error", message: "No se pudo eliminar de favoritos")
            }
        }
    }
    
    private func animateButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = CGAffineTransform.identity
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CatFavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatFavoriteCell", for: indexPath) as? CatFavoriteCell else {
            return UICollectionViewCell()
        }
        
        let favorite = viewModel.favorites[indexPath.item]
        
        cell.configure(with: favorite)
        
        cell.favoriteButton.tag = indexPath.item
        cell.favoriteButton.removeTarget(nil, action: nil, for: .allEvents)
        cell.favoriteButton.addTarget(self, action: #selector(removeFavorite(_:)), for: .touchUpInside)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CatFavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 48) / 2
        return CGSize(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favorite = viewModel.favorites[indexPath.item]
        viewModel.fetchBreedDetails(breedId: favorite.breedId) { [weak self] breed in
            guard let self = self, let breed = breed else { return }
            
            DispatchQueue.main.async {
                let detailVM = CatBreedDetailViewModel(breed: breed)
                let detailVC = CatBreedDetailViewController(viewModel: detailVM)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}

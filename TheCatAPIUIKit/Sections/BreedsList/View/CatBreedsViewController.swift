//
//  CatBreedsViewController.swift
//  TheCatAPIUIKit
//
//  Created by joan on 04/04/25.
//

import UIKit

class CatBreedsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = CatBreedsViewModel()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.backgroundColor = .systemGroupedBackground
        tv.register(CatBreedCell.self, forCellReuseIdentifier: CatBreedCell.identifier)
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Buscar por nombre..."
        sc.searchBar.searchTextField.backgroundColor = .systemGray6
        sc.searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return sc
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No hay razas que mostrar"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadBreeds()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Razas de Gatos"
        view.backgroundColor = .systemGroupedBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupBindings() {
        viewModel.onBreedsLoaded = { [weak self] in
            if self?.viewModel.isLoading == false {
                self?.activityIndicator.stopAnimating()
                self?.updateEmptyState()
            }
            self?.tableView.reloadData()
            self?.updateEmptyState()
        }
        
        viewModel.onLoadingStateChanged = { [weak self] in
            if self?.viewModel.isLoading == true {
                self?.activityIndicator.startAnimating()
                self?.emptyStateLabel.isHidden = true
            }
        }
        
        viewModel.onErrorOccurred = { [weak self] errorMessage in
            if self?.viewModel.isLoading == false {
                self?.activityIndicator.stopAnimating()
                self?.updateEmptyState()
            }
            self?.showAlert(title: "Error", message: errorMessage)
        }
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !viewModel.filteredBreeds.isEmpty
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CatBreedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredBreeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatBreedCell.identifier, for: indexPath) as? CatBreedCell else {
            return UITableViewCell()
        }
        
        let breed = viewModel.filteredBreeds[indexPath.row]
        cell.configure(with: breed)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CatBreedsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let breed = viewModel.filteredBreeds[indexPath.row]
        let detailVC = CatBreedDetailViewController(viewModel: CatBreedDetailViewModel(breed: breed))
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

// MARK: - UISearchResultsUpdating
extension CatBreedsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.filterBreeds(with: searchText)
        }
    }
}

//
//  CatBreedDetailViewModel.swift
//  TheCatAPIUIKit
//
//  Created by joan on 05/04/25.
//

import Foundation
import UIKit

class CatBreedDetailViewModel {
    
    // MARK: - Properties
    let breed: CatBreed
    private(set) var breedImages: [CatImage] = []
    private(set) var isLoading = false
    private(set) var isFavorite = false
    
    private let apiService = CatAPIService.shared
    private let favoritesService = FavoritesPersistenceService.shared
    
    // MARK: - Callbacks
    var onImagesLoaded: (() -> Void)?
    var onLoadingStateChanged: (() -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    var onFavoriteStatusChanged: ((Bool) -> Void)?
    
    // MARK: - Initialization
    init(breed: CatBreed) {
        self.breed = breed
        checkIfIsFavorite()
    }
    
    // MARK: - Public Methods
    func loadBreedImages() {
        isLoading = true
        onLoadingStateChanged?()
        
        apiService.fetchBreedImages(breedId: breed.id) { [weak self] images, error in
            guard let self = self else { return }
            
            self.isLoading = false
            self.onLoadingStateChanged?()
            
            if let error = error {
                self.onErrorOccurred?(error.localizedDescription)
                return
            }
            
            if let images = images, !images.isEmpty {
                self.breedImages = images
                self.onImagesLoaded?()
            } else {
                self.onErrorOccurred?("No images available for this breed.")
            }
        }
    }
    
    func addToFavorites(imageId: String, completion: @escaping (Bool, Error?) -> Void) {
        let favoriteData = FavoriteData(
            breedId: breed.id,
            breedName: breed.name,
            imageId: imageId,
            origin: breed.origin,
            temperament: breed.temperament
        )
        
        favoritesService.saveFavorite(favoriteData) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.isFavorite = true
                    self?.onFavoriteStatusChanged?(true)
                }
                completion(success, error)
            }
        }
    }
    
    func removeFromFavorites() {
        favoritesService.removeFavorite(breedId: breed.id) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.isFavorite = false
                    self?.onFavoriteStatusChanged?(false)
                }
            }
        }
    }
    
    private func checkIfIsFavorite() {
        favoritesService.isFavorite(breedId: breed.id) { [weak self] isFavorite in
            DispatchQueue.main.async {
                self?.isFavorite = isFavorite
                self?.onFavoriteStatusChanged?(isFavorite)
            }
        }
    }
}

//
//  CatFavoritesViewModel.swift
//  TheCatAPIUIKit
//
//  Created by joan on 06/04/25.
//

import Foundation

class CatFavoritesViewModel {
    
    // MARK: - Properties
    private(set) var favorites: [FavoriteData] = []
    private(set) var isLoading = false
    private let favoritesService = FavoritesPersistenceService.shared
    private let apiService = CatAPIService.shared
    
    // MARK: - Callbacks
    var onFavoritesLoaded: (() -> Void)?
    var onLoadingStateChanged: (() -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    
    // MARK: - Public Methods
    func loadFavorites() {
        isLoading = true
        onLoadingStateChanged?()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            let favorites = self.favoritesService.getFavorites().sorted(by: { $0.timestamp > $1.timestamp })
            
            DispatchQueue.main.async {
                self.favorites = favorites
                self.isLoading = false
                self.onLoadingStateChanged?()
                self.onFavoritesLoaded?()
            }
        }
    }
    
    func removeFavorite(breedId: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        onLoadingStateChanged?()
        
        favoritesService.removeFavorite(breedId: breedId) { [weak self] success in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if success {
                    if let index = self.favorites.firstIndex(where: { $0.breedId == breedId }) {
                        self.favorites.remove(at: index)
                    }
                    self.onFavoritesLoaded?()
                }
                
                self.isLoading = false
                self.onLoadingStateChanged?()
                completion(success)
            }
        }
    }
    
    func fetchBreedDetails(breedId: String, completion: @escaping (CatBreed?) -> Void) {
        apiService.fetchBreedDetails(breedId: breedId) { breed, error in
            completion(breed)
        }
    }
    
    func cancelLoading() {
        isLoading = false
        onLoadingStateChanged?()
    }
}

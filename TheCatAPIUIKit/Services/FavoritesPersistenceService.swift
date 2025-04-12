//
//  FavoritesPersistenceService.swift
//  TheCatAPIUIKit
//
//  Created by joan on 06/04/25.
//

import Foundation

struct FavoriteData: Codable {
    let breedId: String
    let breedName: String
    let imageId: String
    let origin: String
    let temperament: String
    let timestamp: Date
    
    init(breedId: String, breedName: String, imageId: String, origin: String, temperament: String) {
        self.breedId = breedId
        self.breedName = breedName
        self.imageId = imageId
        self.origin = origin
        self.temperament = temperament
        self.timestamp = Date()
    }
}

class FavoritesPersistenceService {
    static let shared = FavoritesPersistenceService()
    private let favoritesKey = "cat_favorites"
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Save Favorite
    func saveFavorite(_ favorite: FavoriteData, completion: @escaping (Bool, Error?) -> Void) {
        do {
            var favorites = getFavorites()
            
            if let existingIndex = favorites.firstIndex(where: { $0.breedId == favorite.breedId }) {
                favorites.remove(at: existingIndex)
            }
            
            favorites.append(favorite)
            
            try saveFavorites(favorites)
            completion(true, nil)
        } catch {
            print("Error saving favorite: \(error)")
            completion(false, error)
        }
    }
    
    // MARK: - Remove Favorite
    func removeFavorite(breedId: String, completion: @escaping (Bool) -> Void) {
        var favorites = getFavorites()
        
        if let index = favorites.firstIndex(where: { $0.breedId == breedId }) {
            favorites.remove(at: index)
            
            do {
                try saveFavorites(favorites)
                completion(true)
            } catch {
                print("Error removing favorite: \(error)")
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
    // MARK: - Get All Favorites
    func getFavorites() -> [FavoriteData] {
        guard let data = userDefaults.data(forKey: favoritesKey) else {
            return []
        }
        
        do {
            let favorites = try JSONDecoder().decode([FavoriteData].self, from: data)
            return favorites
        } catch {
            print("Error decoding favorites: \(error)")
            
            resetFavorites()
            return []
        }
    }
    
    // MARK: - Check if is Favorite
    func isFavorite(breedId: String, completion: @escaping (Bool) -> Void) {
        let favorites = getFavorites()
        let isFavorite = favorites.contains { $0.breedId == breedId }
        completion(isFavorite)
    }
    
    // MARK: - Helper Methods
    private func saveFavorites(_ favorites: [FavoriteData]) throws {
        let data = try JSONEncoder().encode(favorites)
        userDefaults.set(data, forKey: favoritesKey)
    }
    
    func resetFavorites() {
        userDefaults.removeObject(forKey: favoritesKey)
    }
}

//
//  CatBreedsViewModel.swift
//  TheCatAPIUIKit
//
//  Created by joan on 04/04/25.
//

import Foundation

class CatBreedsViewModel {
    private(set) var breeds: [CatBreed] = []
    private(set) var filteredBreeds: [CatBreed] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    var onBreedsLoaded: (() -> Void)?
    var onLoadingStateChanged: (() -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    
    func loadBreeds() {
        isLoading = true
        onLoadingStateChanged?()
        
        CatAPIService.shared.fetchBreeds { [weak self] breeds, error in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.onErrorOccurred?(error.localizedDescription)
                return
            }
            
            if let breeds = breeds {
                self.breeds = breeds
                self.filteredBreeds = breeds
                self.onBreedsLoaded?()
            }
        }
    }
    
    func filterBreeds(with searchText: String) {
        if searchText.isEmpty {
            filteredBreeds = breeds
        } else {
            filteredBreeds = breeds.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        onBreedsLoaded?()
    }
}

//
//  API.swift
//  TheCatAPIUIKit
//
//  Created by joan on 04/04/25.
//

import Foundation

class CatAPIService {
    static let shared = CatAPIService()
    
    private init() {}
    
    private let baseURL = "https://api.thecatapi.com/v1"
    private let apiKey = "live_xjgpqFublNE21fIlYFkMauM7bs1DaeXPgMQbjaFRtPTb3kDBBsFWLJ5RHRfl7WBb"
    
    private let userId = "user123"
    
    func fetchBreeds(completion: @escaping ([CatBreed]?, Error?) -> Void) {
        let endpoint = "/breeds"
        performRequest(endpoint: endpoint, queryItems: nil, expecting: [CatBreed].self, completion: completion)
    }
        
    func fetchBreedDetails(breedId: String, completion: @escaping (CatBreed?, Error?) -> Void) {
        let endpoint = "/breeds/\(breedId)"
        
        performRequest(endpoint: endpoint, queryItems: [], expecting: CatBreed.self) { breed, error in
            DispatchQueue.main.async {
                completion(breed, error)
            }
        }
    }
    
    func fetchBreedImages(breedId: String, completion: @escaping ([CatImage]?, Error?) -> Void) {
        let endpoint = "/images/search"
        let queryItems = [
            URLQueryItem(name: "breed_ids", value: breedId),
            URLQueryItem(name: "limit", value: "8")
        ]
        
        performRequest(endpoint: endpoint, queryItems: queryItems, expecting: [CatImage].self, completion: completion)
    }
    
    private func performRequest<T: Decodable>(endpoint: String, queryItems: [URLQueryItem]?, expecting: T.Type, completion: @escaping (T?, Error?) -> Void) {
        var components = URLComponents(string: baseURL + endpoint)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            completion(nil, NSError(domain: "CatAPIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    completion(nil, NSError(domain: "CatAPIService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(decodedData, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}

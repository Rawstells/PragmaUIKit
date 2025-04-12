//
//  CatImage.swift
//  TheCatAPIUIKit
//
//  Created by joan on 04/04/25.
//

import Foundation

struct CatImage: Codable, Identifiable {
    let id: String
    let url: String
    let width: Int
    let height: Int
    
    var breeds: [CatBreed]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case width
        case height
        case breeds
    }
}

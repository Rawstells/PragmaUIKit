//
//  CatBreed.swift
//  TheCatAPIUIKit
//
//  Created by joan on 04/04/25.
//

import Foundation

struct CatBreed: Codable, Identifiable {
    let id: String
    let name: String
    let temperament: String
    let description: String
    let origin: String
    let lifeSpan: String
    let adaptability: Int
    let affectionLevel: Int
    let childFriendly: Int
    let dogFriendly: Int
    let energyLevel: Int
    let healthIssues: Int
    let intelligence: Int
    let socialNeeds: Int
    let strangerFriendly: Int
    let wikipediaUrl: String?
    let referenceImageId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case temperament
        case description
        case origin
        case lifeSpan = "life_span"
        case adaptability
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case healthIssues = "health_issues"
        case intelligence
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case wikipediaUrl = "wikipedia_url"
        case referenceImageId = "reference_image_id"
    }
}

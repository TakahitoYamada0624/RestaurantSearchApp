//
//  Restaurant.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/19.
//

import Foundation

class Result: Decodable {
    let results: Restaurants
    
}

class Restaurants: Decodable {
    let matchCount: Int
    let restaurants: [Restaurant]
    
    enum CodingKeys: String, CodingKey {
        case matchCount = "results_available"
        case restaurants = "shop"
    }
}

class Restaurant: Decodable {
    let name: String
    let access: String
    let photo: Photo
}

class Photo: Decodable {
    let mobile: Thumbnail
}

class Thumbnail: Decodable {
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbnail = "l"
    }
}

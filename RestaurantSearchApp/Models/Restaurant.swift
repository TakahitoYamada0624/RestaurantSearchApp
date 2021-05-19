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
    
    enum CodingKeys: String, CodingKey {
        case matchCount = "results_available"
    }
}

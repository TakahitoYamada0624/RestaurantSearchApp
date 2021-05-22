//
//  RestaurantDetail.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/21.
//

import Foundation

class DetailResult: Decodable {
    let results: DetailRestaurants
}

class DetailRestaurants: Decodable {
    let restaurants: [DetailRestaurant]
    
    enum CodingKeys: String, CodingKey {
        case restaurants = "shop"
    }
}

class DetailRestaurant: Decodable {
    let photo: DetailPhoto
    let name: String
    let open: String
    let address: String
    let access: String
    let budget: Budget
    let budgetRemarks: String
    let card: String
    let genre: Genre
    let course: String
    let freeDrink: String
    let freeFood: String
    
    enum CodingKeys: String, CodingKey {
        case photo
        case name
        case open
        case address
        case access = "mobile_access"
        case budget
        case budgetRemarks = "budget_memo"
        case card
        case genre
        case course
        case freeDrink = "free_drink"
        case freeFood = "free_food"
    }
}

class DetailPhoto: Decodable {
    let mobile: Picture
}

class Picture: Decodable {
    let picture: String
    
    enum CodingKeys: String, CodingKey{
        case picture = "l"
    }
}

class Budget: Decodable {
    let average: String
}

class Genre: Decodable {
    let name: String
}

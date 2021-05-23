//
//  APIRequest.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/22.
//

import Foundation
import CoreLocation
import Alamofire

class APIRequest {
    
    func getRestaurantsInfo(addParameters: [String: Any], completion: @escaping (Restaurants) -> Void) {
        let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?"
        let apiKey = "c7355e2429b8ed1a"
        
        var basicParameters = [
            "key": apiKey,
            "count": 50,
            "format": "json"
        ] as [String : Any]
    
        basicParameters.merge(addParameters) { basic, add in
            return basic
        }
        
        AF.request(url, method: .get, parameters: basicParameters).responseJSON { (response) in
            do{
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                let result = try decoder.decode(Result.self, from: data)
                let restaurants = result.results
                completion(restaurants)
            }catch{
                print("エラーが発生しました。", error)
            }
        }
    }
    
    func getRestaurantDetailInfo(id: String, completion: @escaping (DetailRestaurant) -> Void) {
        let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?"
        let apiKey = "c7355e2429b8ed1a"
        
        let parameters = [
            "key": apiKey,
            "id": id,
            "format": "json"
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            do{
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                let detailResult = try decoder.decode(DetailResult.self, from: data)
                guard let detailRestaurant = detailResult.results.restaurants.first else {return}
                completion(detailRestaurant)
            }catch{
                print("エラーが発生しました。", error)
            }
        }
    }
}

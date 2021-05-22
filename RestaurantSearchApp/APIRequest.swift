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
    
    func getRestaurantsInfo(lat: CLLocationDegrees, lng: CLLocationDegrees, range: Int, start: Int,
                            completion: @escaping (Restaurants) -> Void) {
        let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?"
        let apiKey = "c7355e2429b8ed1a"
        
        let parameters = [
            "key": apiKey,
            "lat": lat,
            "lng": lng,
            "range": range,
            "count": 50,
            "start": start,
            "format": "json"
        ] as [String : Any]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            do{
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                let result = try decoder.decode(Result.self, from: data)
                let restaurants = result.results
                print("before")
                completion(restaurants)
            }catch{
                print("エラーが発生しました。", error)
            }
        }
        
    }
}

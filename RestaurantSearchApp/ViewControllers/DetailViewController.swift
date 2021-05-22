//
//  DetailViewController.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/21.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    
    @IBOutlet weak var basicInformationView: BasicInformationView!
    @IBOutlet weak var paymentView: PaymentView!
    @IBOutlet weak var foodDrinkView: FoodDrinkView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    private let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?"
    private let apiKey = "c7355e2429b8ed1a"
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRestaurantDetailInfo()
    }
    
    func getRestaurantDetailInfo() {
        let parameter = [
            "key": apiKey,
            "id": id,
            "format": "json"
        ]
        
        AF.request(url, method: .get, parameters: parameter).responseJSON { (response) in
            do {
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                let result = try decoder.decode(DetailResult.self, from: data)
                guard let restaurant = result.results.restaurants.first else {return}
                self.passValue(restaurant: restaurant)
            }catch{
                print("エラーが発生しました。", error)
            }
        }
    }
    
    func passValue(restaurant: DetailRestaurant) {
        basicInformationView.name = restaurant.name
        basicInformationView.open = restaurant.open
        basicInformationView.address = restaurant.address
        basicInformationView.access = restaurant.access
        paymentView.average = restaurant.budget.average
        paymentView.budgetRemarks = restaurant.budgetRemarks
        paymentView.card = restaurant.card
        foodDrinkView.genre = restaurant.genre.name
        foodDrinkView.course = restaurant.course
        foodDrinkView.freeDrink = restaurant.freeDrink
        foodDrinkView.freeFood = restaurant.freeFood
        let str = restaurant.photo.mobile.picture
        guard let url = URL(string: str) else {return}
        do {
            let data = try Data(contentsOf: url)
            restaurantImageView.image = UIImage(data: data)
            restaurantImageView.contentMode = .scaleAspectFill
        }catch{
            print("失敗しました。")
        }
    }
}

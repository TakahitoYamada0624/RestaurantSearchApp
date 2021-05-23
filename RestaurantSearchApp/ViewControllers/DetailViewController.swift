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
    
    var id: String = ""
    let apiRequest = APIRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRestaurantDetailInfo()
    }
    
    func getRestaurantDetailInfo() {
        apiRequest.getRestaurantDetailInfo(id: id) { (restaurant) in
            self.passValue(restaurant: restaurant)
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

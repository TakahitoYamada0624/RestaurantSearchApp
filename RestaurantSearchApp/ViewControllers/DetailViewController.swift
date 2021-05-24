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
    var rightButtonItem: UIBarButtonItem!
    
    var id: String = ""
    let apiRequest = APIRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRestaurantDetailInfo()
        checkFavRestaurant()
    }
    
    func checkFavRestaurant() {
        let favRestaurants = UserDefaults.standard.object(forKey: "favRestaurantsId") as? [String]
        if let _ = favRestaurants?.firstIndex(of: id){
            let image = UIImage(systemName: "heart")
            rightButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addOrReplaceFavorite))
            rightButtonItem.tintColor = .systemPink
            navigationItem.rightBarButtonItem = rightButtonItem
        }else{
            let image = UIImage(systemName: "heart.slash")
            rightButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addOrReplaceFavorite))
            navigationItem.rightBarButtonItem = rightButtonItem
        }
    }
    
    @objc func addOrReplaceFavorite() {
        guard var favRestaurantsId = UserDefaults.standard.object(forKey: "favRestaurantsId") as? [String] else {
            UserDefaults.standard.set([id], forKey: "favRestaurantsId")
            let image = UIImage(systemName: "heart")
            rightButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addOrReplaceFavorite))
            rightButtonItem.tintColor = .systemPink
            navigationItem.rightBarButtonItem = rightButtonItem
            return
        }
        
        if let firstIndex = favRestaurantsId.firstIndex(of: id) {
            favRestaurantsId.remove(at: firstIndex)
            UserDefaults.standard.set(favRestaurantsId, forKey: "favRestaurantsId")
            let image = UIImage(systemName: "heart.slash")
            rightButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addOrReplaceFavorite))
            navigationItem.rightBarButtonItem = rightButtonItem
            
        }else{
            favRestaurantsId.append(id)
            UserDefaults.standard.set(favRestaurantsId, forKey: "favRestaurantsId")
            let image = UIImage(systemName: "heart")
            rightButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addOrReplaceFavorite))
            rightButtonItem.tintColor = .systemPink
            navigationItem.rightBarButtonItem = rightButtonItem
        }
    }
    
    func getRestaurantDetailInfo() {
        apiRequest.getRestaurantDetailInfo(id: id) { (restaurant) in
            self.passValue(restaurant: restaurant)
        }
    }
    
    func passValue(restaurant: DetailRestaurant) {
        basicInformationView.name = restaurant.name
        self.navigationItem.title = restaurant.name
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
            restaurantImageView.contentMode = .scaleAspectFit
        }catch{
            print("データへの変更に失敗しました。")
        }
    }
}

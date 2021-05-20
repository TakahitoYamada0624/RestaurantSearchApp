//
//  RestaurantsViewController.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/13.
//

import UIKit
import Alamofire

class RestaurantsViewController: UIViewController {
    
    @IBOutlet weak var restaurantsTableView: UITableView!
    
    var restaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantsTableView.dataSource = self
        restaurantsTableView.delegate = self
        restaurantsTableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "RestaurantCell")
        getRestarantsInfo()
    }
    
    func getRestarantsInfo() {
        let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?"
        let apiKey = "c7355e2429b8ed1a"
        let parameters = [
            "key": apiKey,
            "lat": 35.680959106959,
            "lng": 139.76730676352,
            "range": 3,
            "count": 50,
            "format": "json"
        ] as [String : Any]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            do {
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                let result = try decoder.decode(Result.self, from: data)
                print("result", result.results.restaurants[1].name)
                self.restaurants = result.results.restaurants
                print("restaurants:", self.restaurants.count)
                self.restaurantsTableView.reloadData()
            }catch{
                print("失敗しました", error)
            }
        }
    }
    
}

extension RestaurantsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        let restaurant = restaurants[indexPath.row]
        cell.name = restaurant.name
        cell.access = restaurant.access
        cell.thumnailString = restaurant.photo.mobile.thumbnail
        return cell
    }
    
}

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
    private let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?"
    private let apiKey = "c7355e2429b8ed1a"
    var parameters = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantsTableView.dataSource = self
        restaurantsTableView.delegate = self
        restaurantsTableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "RestaurantCell")
        getRestarantsInfo()
    }
    
    func getRestarantsInfo() {
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            do {
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                let result = try decoder.decode(Result.self, from: data)
                self.restaurants = result.results.restaurants
                print("restaurants:", self.restaurants.count)
                self.restaurantsTableView.reloadData()
            }catch{
                print("失敗しました", error)
            }
        }
    }
    
    func getMoreRestaurantsInfo() {
        //何番目から取得するか
        let numberOfRestaurants: Int = restaurants.count + 1
        parameters.updateValue(numberOfRestaurants, forKey: "start")
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            do {
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                let result = try decoder.decode(Result.self, from: data)
                self.restaurants.append(contentsOf: result.results.restaurants)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let detail = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        let id = restaurants[indexPath.row].id
        detail.id = id
        navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (restaurants.count - 20) {
            getMoreRestaurantsInfo()
            print("count", restaurants.count)
        }
    }
    
}

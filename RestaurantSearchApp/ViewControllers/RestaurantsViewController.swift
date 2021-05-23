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
    var addParameters = [String: Any]()
    let apiRequest = APIRequest()
    var matchCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantsTableView.dataSource = self
        restaurantsTableView.delegate = self
        restaurantsTableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "RestaurantCell")
        getRestarantsInfo()
    }
    
    func getRestarantsInfo() {
        let addParameters = self.addParameters
        apiRequest.getRestaurantsInfo(addParameters: addParameters) { (restaurants) in
            self.restaurants = restaurants.restaurants
            self.matchCount = restaurants.matchCount
            print("restaurants:", self.restaurants.count)
            self.restaurantsTableView.reloadData()
        }
    }
    
    func getMoreRestaurantsInfo() {
        let numberOfRestaurants: Int = restaurants.count + 1
        addParameters.updateValue(numberOfRestaurants, forKey: "start")
        
        apiRequest.getRestaurantsInfo(addParameters: addParameters) { (restaurants) in
            self.restaurants.append(contentsOf: restaurants.restaurants)
            print("restaurants:", self.restaurants.count)
            self.restaurantsTableView.reloadData()
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
        print("indexpath", indexPath.row)
        let count = restaurants.count
        if indexPath.row == (count - 20) && count != matchCount {
            getMoreRestaurantsInfo()
            print("count", restaurants.count)
        }
    }
    
}

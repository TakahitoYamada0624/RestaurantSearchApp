//
//  SearchViewController.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/17.
//

import UIKit
import CoreLocation
import Alamofire

class SearchViewController: UIViewController {
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locationManager: CLLocationManager!
    
    private var latitude: CLLocationDegrees = 35.680959106959
    private var longitude: CLLocationDegrees = 139.76730676352
    var addParameters = [String: Any]()
    let apiRequest = APIRequest()
    private var notSelectDistance: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        searchBar.delegate = self
        
        getRestaurantsCount()
    }
    
    //スライダーを動かしている時に呼ばれる
    @IBAction func selectDistance(_ sender: Any) {
        
        let value = distanceSlider.value
        
        switch value {
        case 0 ..< 0.2:
            distanceLabel.text = "300m"
            print("300m")
        case 0.2 ..< 0.4:
            distanceLabel.text = "500m"
            print("500m")
        case 0.4 ..< 0.6:
            distanceLabel.text = "1,000m"
            print("1,000m")
        case 0.6 ..< 0.8:
            distanceLabel.text = "2,000m"
            print("2,000m")
        case 0.8 ... 1:
            distanceLabel.text = "3,000m"
            print("3,000m")
        default:
            print("予想外の挙動が起きました")
        }
    }
    
    //スライダーから指が離れた時に呼ばれる
    @IBAction func releasedSlider(_ sender: Any) {
        print("スライダーを外しました")
        notSelectDistance = false
        getRestaurantsCount()
    }
    
    //検索ボタンを押した時に呼ばれる
    @IBAction func searchRestaurants(_ sender: Any) {
        print("検索ボタンが押されました。")
        let storyboard = UIStoryboard(name: "Restaurants", bundle: nil)
        let restaurants = storyboard.instantiateViewController(withIdentifier: "Restaurants") as! RestaurantsViewController
        restaurants.addParameters = self.addParameters
        navigationController?.pushViewController(restaurants, animated: true)
    }
    
    //条件に合うレストラン数を取得する
    func getRestaurantsCount() {
        var range: Int = 0
        let value = distanceSlider.value
        
        switch value {
        case 0 ..< 0.2:
            range = 1
        case 0.2 ..< 0.4:
            range = 2
        case 0.4 ..< 0.6:
            range = 3
        case 0.6 ..< 0.8:
            range = 4
        case 0.8 ... 1:
            range = 5
        default:
            print("予想外の挙動が起きました")
        }
        
        let searchTextIsEmpty = searchBar.text?.isEmpty ?? false
        let notSelectedDistance = notSelectDistance
        var addPara = [String: Any]()
        if searchTextIsEmpty && notSelectedDistance {
            addPara = [
                "large_area": "Z011",
                "start": 1
            ]
        }else if searchTextIsEmpty {
            addPara = [
                "lat": self.latitude,
                "lng": self.longitude,
                "range": range,
                "start": 1
            ]
        }else if notSelectedDistance {
            guard let searchText = searchBar.text else {return}
            addPara = [
                "name_any": searchText,
                "start": 1
            ]
        }else{
            guard let searchText = searchBar.text else {return}
            addPara = [
                "lat": self.latitude,
                "lng": self.longitude,
                "range": range,
                "name_any": searchText,
                "start": 1
            ]
        }
        
        apiRequest.getRestaurantsInfo(addParameters: addPara){ (restaurants) in
            self.searchButton.setTitle("\(restaurants.matchCount)件", for: .normal)
            print("restaurantCount", restaurants.matchCount)
            self.addParameters = addPara
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        getRestaurantsCount()
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 10
            distanceSlider.isEnabled = true

        case .denied, .restricted:
            print("denied, restricted")
            showAlert()
            distanceSlider.isEnabled = false
            notSelectDistance = true

        case .notDetermined:
            print("notDetermined")
            manager.requestWhenInUseAuthorization()
            distanceSlider.isEnabled = false
            notSelectDistance = true

        default:
            print("扱っていないケースが発生しました。")
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "位置情報の確認", message:  "レストランを検索しやすくするために設定から位置情報を許可してください" , preferredStyle: .alert)
        let ok = UIAlertAction(title: "閉じる", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        guard let latitude = location?.coordinate.latitude else {return}
        guard let longitude = location?.coordinate.longitude else {return}
        self.latitude = latitude
        self.longitude = longitude
        print("latitude:", self.latitude)
        print("longitude:", self.longitude)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getRestaurantsCount()
    }
}

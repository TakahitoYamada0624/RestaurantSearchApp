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
    
    let apiRequest = APIRequest()
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favResCollectionView: UICollectionView!
    
    var locationManager: CLLocationManager!
    private var latitude: CLLocationDegrees = 35.680959106959
    private var longitude: CLLocationDegrees = 139.76730676352
    var addParameters = [String: Any]()
    private var notSelectDistance: Bool = true
    var favRestaurantsId = UserDefaults.standard.object(forKey: "favRestaurantsId") as? [String]
    var favRestaurands = [DetailRestaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        searchBar.delegate = self
        
        favResCollectionView.register(UINib(nibName: "FavRestaurantCell", bundle: nil), forCellWithReuseIdentifier: "FavRestaurantCell")
        favResCollectionView.dataSource = self
        favResCollectionView.delegate = self
        
        getRestaurantsCount()
        getFavRestaurantsInfo()
        observeUserDefault()
        setupLayout()
    }
    
    func setupLayout() {
        navigationItem.title = "検索画面"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 200, height: 200)
        favResCollectionView.collectionViewLayout = layout
    }
    
    @IBAction func selectDistance(_ sender: Any) {
        
        let value = distanceSlider.value
        
        switch value {
        case 0 ..< 0.2:
            distanceLabel.text = "300m"
        case 0.2 ..< 0.4:
            distanceLabel.text = "500m"
        case 0.4 ..< 0.6:
            distanceLabel.text = "1,000m"
        case 0.6 ..< 0.8:
            distanceLabel.text = "2,000m"
        case 0.8 ... 1:
            distanceLabel.text = "3,000m"
        default:
            showAlert(title: "エラー", message: "不正な値です")
        }
    }
    
    //スライダーから指が離れた時に呼ばれる
    @IBAction func releasedSlider(_ sender: Any) {
        notSelectDistance = false
        getRestaurantsCount()
    }
    
    //検索ボタンを押した時に呼ばれる
    @IBAction func searchRestaurants(_ sender: Any) {
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
            showAlert(title: "エラー", message: "不正な値です")
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
            if restaurants.matchCount == 0 {
                self.searchButton.isEnabled = false
                self.searchButton.setTitle("\(restaurants.matchCount)件", for: .normal)
                self.addParameters = addPara
            }else{
                self.searchButton.isEnabled = true
                self.searchButton.setTitle("\(restaurants.matchCount)件", for: .normal)
                self.addParameters = addPara
            }
        }
    }
    
    func getFavRestaurantsInfo() {
        guard let favRestaurantsId = favRestaurantsId else {return}
        favRestaurands.removeAll()
        for favRestaurantId in favRestaurantsId {
            apiRequest.getRestaurantDetailInfo(id: favRestaurantId) { (restaurant) in
                self.favRestaurands.append(restaurant)
                self.favResCollectionView.reloadData()
            }
        }
    }
    
    func observeUserDefault() {
        UserDefaults.standard.addObserver(self, forKeyPath: "favRestaurantsId", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.favRestaurantsId = UserDefaults.standard.object(forKey: "favRestaurantsId") as? [String]
        if favRestaurantsId == [] {
            favRestaurands.removeAll()
            favResCollectionView.reloadData()
        }else{
            getFavRestaurantsInfo()
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
            showAlert(title: "位置情報の確認",
                      message: "レストランを検索しやすくするために設定から位置情報を許可してください")
            distanceSlider.isEnabled = false
            notSelectDistance = true

        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            distanceSlider.isEnabled = false
            notSelectDistance = true

        default:
            print("扱っていないケースが発生しました。")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
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
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getRestaurantsCount()
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favRestaurands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavRestaurantCell", for: indexPath) as! FavRestaurantCell
        let restaurantInfo = favRestaurands[indexPath.row]
        cell.imageStr = restaurantInfo.photo.mobile.picture
        cell.name = restaurantInfo.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let detail = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        let restaurantInfo = favRestaurands[indexPath.row]
        detail.id = restaurantInfo.id
        navigationController?.pushViewController(detail, animated: true)
    }
}

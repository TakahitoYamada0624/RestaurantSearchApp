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
    
    var locationManager: CLLocationManager!
    
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
    }
    
    //スライダーを動かしている時に呼ばれる
    @IBAction func selectDistance(_ sender: Any) {
        let value = distanceSlider.value
        
        switch value {
        case 0 ..< 0.2:
            print("300m")
        case 0.2 ..< 0.4:
            print("500m")
        case 0.4 ..< 0.6:
            print("1,000m")
        case 0.6 ..< 0.8:
            print("2,000m")
        case 0.8 ... 1:
            print("3,000m")
        default:
            print("予想外の挙動が起きました")
        }
        print("value: ", value)
    }
    
    //スライダーから指が離れた時に呼ばれる
    @IBAction func releasedSlider(_ sender: Any) {
        print("スライダーを外しました")
        getRestaurantsCount()
    }
    
    //検索ボタンを押した時に呼ばれる
    @IBAction func searchRestaurants(_ sender: Any) {
        print("検索ボタンが押されました。")
    }
    
    //条件に合うレストラン数を取得する
    func getRestaurantsCount() {
        let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?"
        let apiKey = "c7355e2429b8ed1a"
        let lat = self.latitude
        let lng = self.longitude
        var distance: Int?
        
        let value = distanceSlider.value
        
        switch value {
        case 0 ..< 0.2:
            distance = 1
        case 0.2 ..< 0.4:
            distance = 2
        case 0.4 ..< 0.6:
            distance = 3
        case 0.6 ..< 0.8:
            distance = 4
        case 0.8 ... 1:
            distance = 5
        default:
            print("予想外の挙動が起きました")
        }
        
        let parameters = [
            "key": apiKey,
            "lat": lat,
            "lng": lng,
            "range": distance!,
            "format": "json"
        ] as [String : Any]
        
        print("parameters", parameters)
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            do {
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                let result = try decoder.decode(Result.self, from: data)
                self.searchButton.setTitle("\(result.results.matchCount)件", for: .normal)
                print("\(result.results.matchCount)件")
            }catch{
                print("変換に失敗しました。", error)
            }
        }
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("authorizedAlways")
            
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            print("denied, restricted")
            showAlert()
            
        case .notDetermined:
            print("notDetermined")
            manager.requestWhenInUseAuthorization()
            
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
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        self.latitude = 35.680959106959
        self.longitude = 139.76730676352
        print("latitude:", self.latitude)
        print("longitude:", self.longitude)
    }
    
}

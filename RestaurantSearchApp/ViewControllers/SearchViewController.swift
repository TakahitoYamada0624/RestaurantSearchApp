//
//  SearchViewController.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/17.
//

import UIKit
import CoreLocation

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
        
    }
    
    //検索ボタンを押した時に呼ばれる
    @IBAction func searchRestaurants(_ sender: Any) {
        print("検索ボタンが押されました。")
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
//        self.latitude = latitude ?? 0
//        self.longitude = longitude ?? 0
        self.latitude = 35.680959106959
        self.longitude = 139.76730676352
        print("latitude:", self.latitude)
        print("longitude:", self.longitude)
    }
    
}

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
    
    private let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?"
    private let apiKey = "c7355e2429b8ed1a"
    
    var id: String = "J001251597"
    
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
                print("result", result.results.restaurants.first?.address)
                self.basicInformationView.name = result.results.restaurants[0].name
            }catch{
                print("エラーが発生しました。", error)
            }
        }
    }
}

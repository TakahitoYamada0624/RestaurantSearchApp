//
//  RestaurantsViewController.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/13.
//

import UIKit

class RestaurantsViewController: UIViewController {
    
    @IBOutlet weak var restaurantsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantsTableView.dataSource = self
        restaurantsTableView.delegate = self
        restaurantsTableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "RestaurantCell")
        
    }
    
}

extension RestaurantsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
        return cell
    }
    
}

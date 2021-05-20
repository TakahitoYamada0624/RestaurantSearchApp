//
//  RestaurantCell.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/14.
//

import Foundation
import UIKit

class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var access: String? {
        didSet {
            accessLabel.text = access
        }
    }
    
    var thumnailString: String? {
        didSet {
            guard let url = URL(string: thumnailString ?? "") else {return}
            do {
                let data = try Data(contentsOf: url)
                thumbnailImageView.image = UIImage(data: data)
                thumbnailImageView.contentMode = .scaleAspectFill
            }catch{
                print("データの変換に失敗しました。")
            }
        }
    }
    
}

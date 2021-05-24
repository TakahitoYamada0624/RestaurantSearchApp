//
//  FavRestaurantCell.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/24.
//

import UIKit

class FavRestaurantCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var imageStr: String? {
        didSet {
            do {
                guard let url = URL(string: imageStr ?? "") else {return}
                let data = try Data(contentsOf: url)
                imageView.image = UIImage(data: data)
            }catch{
                print("変換に失敗しました。")
            }
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
}

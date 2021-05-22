//
//  FoodDrinkView.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/21.
//

import UIKit

class FoodDrinkView: UIView {
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var freeDrinkLabel: UILabel!
    @IBOutlet weak var freeFoodLabel: UILabel!
    
    var genre: String? {
        didSet {
            genreLabel.text = "ジャンル：\(genre ?? "未詳")"
        }
    }
    
    var course: String? {
        didSet {
            courseLabel.text = "コース：\(course ?? "未詳")"
        }
    }
    
    var freeDrink: String? {
        didSet{
            freeDrinkLabel.text = "飲み放題：\(freeDrink ?? "未詳")"
        }
    }
    
    var freeFood: String? {
        didSet {
            freeFoodLabel.text = "食べ放題：\(freeFood ?? "未詳")"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    func loadNib() {
        let view = Bundle.main.loadNibNamed("FoodDrinkView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
    }
    
}

//
//  BasicInformationView.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/21.
//

import UIKit

class BasicInformationView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var open: String? {
        didSet {
            openLabel.text = "営業時間：\(open ?? "未詳")"
        }
    }
    
    var address: String? {
        didSet {
            addressLabel.text = "住所：\(address ?? "未詳")"
        }
    }
    
    var access: String? {
        didSet {
            accessLabel.text = "アクセス：\(access ?? "未詳")"
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
        let view = Bundle.main.loadNibNamed("BasicInformationView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
    }
}

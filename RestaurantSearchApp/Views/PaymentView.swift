//
//  PaymentView.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/21.
//

import UIKit

class PaymentView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    func loadNib() {
        let view = Bundle.main.loadNibNamed("PaymentView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
    }
}

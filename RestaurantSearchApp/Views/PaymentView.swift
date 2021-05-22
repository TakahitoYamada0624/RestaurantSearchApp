//
//  PaymentView.swift
//  RestaurantSearchApp
//
//  Created by Takahito Yamada on 2021/05/21.
//

import UIKit

class PaymentView: UIView {
    
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var budgetRemarksLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    
    var average: String? {
        didSet {
            averageLabel.text = "平均予算：\(average ?? "未詳")"
        }
    }
    
    var budgetRemarks: String? {
        didSet {
            budgetRemarksLabel.text = "料金備考：\(budgetRemarks ?? "未詳")"
        }
    }
    
    var card: String? {
        didSet {
            cardLabel.text = "カードの利用：\(card ?? "未詳")"
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
        let view = Bundle.main.loadNibNamed("PaymentView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
    }
}

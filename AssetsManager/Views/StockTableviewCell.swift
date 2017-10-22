//
//  StockTableviewCell.swift
//  AssetsManager
//
//  Created by min on 10/13/17.
//  Copyright © 2017 min. All rights reserved.
//

import Foundation
import UIKit

class ShadowView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupShadow()
    }
    
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.6
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.shadowColor = UIColor.untPinkishGrey38.cgColor
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}


class StockTableviewCell: UITableViewCell {
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var epsEstimate: UILabel!
    
}

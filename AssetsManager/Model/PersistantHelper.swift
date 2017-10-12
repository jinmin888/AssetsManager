//
//  PersistantHelper.swift
//  AssetsManager
//
//  Created by min on 12/10/2017.
//  Copyright © 2017 min. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PersistantHelper {
    let rootName = "stocks"
    
    func addStock(stock:Stock){
        self.dbReference(stock.stockName).setValue(stock.toJSON())
    }
    
    private func dbReference() -> DatabaseReference {
        return Database.database().reference().child(rootName)
    }
    private func dbReference(_ byStock:String) -> DatabaseReference {
        return self.dbReference().child(byStock)
    }
    
}

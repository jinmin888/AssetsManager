//
//  PersistantHelper.swift
//  AssetsManager
//
//  Created by min on 12/10/2017.
//  Copyright © 2017 min. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

protocol PersistantHelper {
    
}

class FirestorePersistantHelper:PersistantHelper {
    
    static let shared = FirestorePersistantHelper()
    
    public func addStock(stock:Stock){
        stockDatabaseInstance().document(stock.stockCode).setData(stock.toJSON());
    }
    
    public func stockDataInstance(_ day:String) -> CollectionReference {
        return Firestore.firestore().collection("Korea").document("stockmarket").collection(day)
    }
    
    public func addStocks(stocks:Array<Stock>,_ completion:(Error)) -> Void{
        stocks.forEach { stock in
            addStock(stock: stock)
        }
    }
    
    private func stockDatabaseInstance() -> CollectionReference {
        return Firestore.firestore().collection("Korea").document("stockmarket").collection(Utility.currentDate())
    }
    
}

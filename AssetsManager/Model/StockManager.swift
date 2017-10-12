//
//  StockManager.swift
//  AssetsManager
//
//  Created by min on 12/10/2017.
//  Copyright © 2017 min. All rights reserved.
//

import Foundation
import Alamofire

class StockManager {
    var stockList:[Stock] = []
    var myGroup:DispatchGroup?
    
    func test(){
        self.stockList = self.getStockListFormLocal()
        for stock in self.stockList {
            DispatchQueue(label: "queuename").async {
                self.updateStockInfo(stock)
            }
        }
        
        DispatchQueue(label: "queuename").async {
            self.myGroup?.wait();
            print(self.stockList);
        }
        
    }
    
    private func updateStockInfo(_ stock:Stock){
        self.myGroup?.enter();
        let parameters: Parameters = ["flag": 2,"cmp_cd":stock.stockCode,"finGubun":"MAIN","frq":0,"sDT":"20171009","chartType":"svg"]
        Alamofire.request("http://companyinfo.stock.naver.com/company/ajax/c1050001_data.aspx", method: .get, parameters: parameters).validate().responseJSON { response in
            let data = response.result.value as! NSDictionary
            if let objs = data["JsonData"] as! NSArray? {
                stock.update(data:objs)
                PersistantHelper().addStock(stock: stock)
                self.myGroup?.leave();
            }
        }
    }
    
    private func getStockListFormLocal() -> Array<Stock> {
        let path:String! = Bundle.main.path(forResource: "stocks", ofType: "plist")
        let stocks:NSDictionary! = NSDictionary(contentsOfFile:path)
        var list:Array<Stock> = [];
        for code in stocks.allKeys as! [String]{
            var stock:Stock = Stock()
            stock.stockCode = code
            stock.stockName = stocks.value(forKey: code) as! String
            list.append(stock)
        }
        return list
    }
    
    
    
    

}

//
//  StockManager.swift
//  AssetsManager
//
//  Created by min on 12/10/2017.
//  Copyright © 2017 min. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseDatabase

class StockManager {
    var stockList:[Stock] = []
    var myGroup:DispatchGroup?
    static let shared = StockManager()
    
    public func getStock(_ forDate:String, completion:@escaping (_ list:Array<Stock>,_ error:Any?)->Void){
        FirestorePersistantHelper.shared.stockDataInstance(forDate).getDocuments{ (snapshot, error) in
            var list = Array<Stock>()
            snapshot?.documents.forEach({ (document) in
                list.append(Stock(data: document.data()))
            })
//            list.sort(by: { (stock1, stock2) -> Bool in
//                if(stock1.fwd24MEpsCompondIncrease > stock2.fwd24MEpsCompondIncrease){
//                    return true
//                }
//                else{
//                    return false
//                }
//            })
            completion(list,error)
        }
    }
    
    public func checkEpsChange(startDate:String,endDate:String,completeHandler:@escaping (_ list:NSMutableDictionary)->Void){
        getStock(endDate) { (stockList, error) in
            self.getStock(startDate, completion: { (startStockList, secondError) in
                stockList.forEach({ endStock in
                    if let found = startStockList.index(where: {$0.stockCode == endStock.stockCode}){
                        let epsChanges = endStock.epsChange(stock: startStockList[found])
                        completeHandler(epsChanges)
                    }
                })
            })
        }
    }
    
    public func syncDataFromNaver(){
        if(Utility.isWeekend()){
            print("Today is weekend, No need to sync data")
            return
        }
        self.stockList = self.getStockListFormLocal()
        for stock in self.stockList {
            self.updateBasicStockInfo(stock)
        }
    }
    
    private func updateBasicStockInfo(_ stock:Stock){
        let url = "http://api.finance.naver.com/service/itemSummary.nhn?itemcode=\(stock.stockCode)"
        Alamofire.request(url, method: .get, parameters: nil).validate().responseJSON { response in
            let data = response.result.value as! NSDictionary
            stock.highPrice = data.object(forKey: "high") as? Double
            stock.lowPrice = data.object(forKey: "low") as? Double
            stock.currentPrice = data.object(forKey: "now") as? Double
            stock.currentPer = data.object(forKey: "per") as? Double
            stock.currentPbr = data.object(forKey: "pbr") as? Double
            stock.amount = data.object(forKey: "amount") as? Double
            self.updateStockInfo(stock)
        }
    }
    
    private func updateStockInfo(_ stock:Stock){
        self.myGroup?.enter();
        let parameters: Parameters = ["flag": 2,"cmp_cd":stock.stockCode,"finGubun":"MAIN","frq":0,"sDT":"20171009","chartType":"svg"]
        Alamofire.request("http://companyinfo.stock.naver.com/company/ajax/c1050001_data.aspx", method: .get, parameters: parameters).validate().responseJSON { response in
            let data = response.result.value as! NSDictionary
            if let objs = data["JsonData"] as! NSArray? {
                stock.update(data:objs)
                FirestorePersistantHelper.shared.addStock(stock: stock)
            }
        }
    }

    public func sortBy(){
        
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

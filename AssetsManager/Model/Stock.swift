//
//  Stock.swift
//  AssetsManager
//
//  Created by min on 12/10/2017.
//  Copyright © 2017 min. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Stock {
    
    var stockCode:String = ""
    var stockName:String = ""
    var currentPer:Optional<Double> = 0
    var currentPbr:Double? = 0
    var openPrice:Double? = 0
    var closePrice:Double? = 0
    var highPrice:Double? = 0
    var lowPrice:Double? = 0
    var amount:Double? = 0
    var currentPrice:Double? = 0
    var historyBPS = NSMutableDictionary()
    var historyEPS = NSMutableDictionary()
    var historyPER = NSMutableDictionary()
    var historyPBR = NSMutableDictionary()
    var futureEPS = NSMutableDictionary()
    var futureBPS = NSMutableDictionary()
    var last5yAvgPer:Double = 0
    var fwd12MEpsCompondIncrease:Double = 0
    var fwd24MEpsCompondIncrease:Double = 0
    var latestUpdateTimestamp = 0
    
    init(){
        
    }
    
    init(data:Dictionary<String, Any>){
        self.highPrice = data["highPrice"] as! Double
        self.amount = data["amount"] as! Double
        self.stockCode = data["code"] as! String
        self.stockName = data["name"] as! String
        self.futureEPS = data["futureEPS"] as! NSMutableDictionary
        self.futureBPS = data["futureBPS"] as! NSMutableDictionary
        self.historyBPS = data["historyBPS"] as! NSMutableDictionary
        self.historyEPS = data["historyEPS"] as! NSMutableDictionary
        self.lowPrice = data["lowPrice"] as? Double
        self.openPrice = data["openPrice"] as? Double
        self.closePrice = data["closePrice"] as? Double
        self.currentPer = data["currentPer"] as? Double
        self.currentPbr = data["currentPbr"] as? Double
        
        if let epsForThisYear = self.futureEPS.object(forKey: "201712") as? String,
           let epsForNextYear = self.futureEPS.object(forKey: "201812") as? String,
           let epsForNextNextYear = self.futureEPS.object(forKey: "201912") as? String{
            if (epsForThisYear.isEmpty || epsForNextYear.isEmpty || epsForNextNextYear.isEmpty){
            }else{
                self.fwd12MEpsCompondIncrease = Double(epsForNextYear as String)!/Double(epsForThisYear as String)!
                self.fwd24MEpsCompondIncrease = sqrt(Double(epsForNextNextYear as String)!/Double(epsForThisYear as String)!)
                self.fwd12MEpsCompondIncrease = (self.fwd12MEpsCompondIncrease - 1 ) * 100
                self.fwd24MEpsCompondIncrease = (self.fwd24MEpsCompondIncrease - 1 ) * 100
            }
        }
    }
    
    func updateWithFirebaseData(data:DataSnapshot){
//        self.forwardEpsCompondIncrease = data.childSnapshot(forPath: "composeEPSIncreaase").value as! Double
        self.stockName = data.key
    }
    
    func update(data:NSArray) {
        let historyDatas = data.subarray(with: NSMakeRange(0, data.count-3)) as! NSArray
        let futureDatas = data.subarray(with: NSMakeRange(data.count-3, 3)) as! NSArray
        self.updateConcenserData(array: historyDatas, epsDic: historyEPS, bpsDic: historyBPS)
        self.updateConcenserData(array: futureDatas, epsDic: futureEPS, bpsDic: futureBPS)
    }
    
    func updateConcenserData(array:NSArray,epsDic:NSDictionary,bpsDic:NSDictionary){
        for ftureData in array  {
            var eps:String = (ftureData as! NSDictionary).value(forKey: "EPS") as! String
            var year:String = (ftureData as! NSDictionary).value(forKey: "YYMM") as! String;
            var bps:String = (ftureData as! NSDictionary).value(forKey: "BPS") as! String;
            epsDic.setValue(self.removeSpecialCharsFromString(text: eps), forKey: self.removeSpecialCharsFromString(text: year))
            bpsDic.setValue(self.removeSpecialCharsFromString(text: bps), forKey: self.removeSpecialCharsFromString(text: year))
        }
    }
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    func epsChange(stock:Stock)->NSMutableDictionary{
        var compareData = NSMutableDictionary()
            self.futureEPS.allKeys.forEach({ key in
                if let thisEps = self.futureEPS.object(forKey: key) as? String , let otherEps = stock.futureEPS.object(forKey: key) as? String {
                    if(!(thisEps.isEmpty && otherEps.isEmpty)){
                        let changes:Double = (Double(thisEps)! - Double(otherEps)!) / Double(otherEps)!
                        compareData.setValue(changes, forKey:key as! String)
                    }
                }
            })
        return compareData
    }
    func toJSON() -> Dictionary <String,Any>! {
        return [
            "highPrice":self.highPrice,
            "lowPrice":self.lowPrice,
            "openPrice":self.openPrice,
            "closePrice":self.currentPrice,
            "currentPer":self.currentPer,
            "currentPbr":self.currentPbr,
            "amount":self.amount,
            "name":stockName,
            "code":stockCode,
            "futureEPS":self.futureEPS,
            "futureBPS":self.futureBPS,
            "historyEPS":self.historyEPS,
            "historyBPS":self.historyBPS,
        ]
    }
}

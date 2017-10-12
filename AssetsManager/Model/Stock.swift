//
//  Stock.swift
//  AssetsManager
//
//  Created by min on 12/10/2017.
//  Copyright © 2017 min. All rights reserved.
//

import Foundation

class Stock {
    var stockCode:String = ""
    var stockName:String = ""
    var currentPer:Double = 0
    var currentPrice:Double = 0
    var historyPrice:[String:Double] = [:]
    var historyEPS:[String:Double] = [:]
    var historyPER:[String:Double] = [:]
    var futureEPS = NSMutableDictionary()
    var futureBPS = NSMutableDictionary();
    var last5yAvgPer:Double = 0
    var forwardEpsCompondIncrease:Double = 0
    var futureEPSIncrease = 0
    var latestUpdateTimestamp = 0
    
    func update(data:NSArray) {
        let futureDatas = data.subarray(with: NSMakeRange(3, 4)) as! NSArray
        for ftureData in futureDatas  {
            var eps:String = (ftureData as! NSDictionary).value(forKey: "EPS") as! String
            var year:String = (ftureData as! NSDictionary).value(forKey: "YYMM") as! String;
            var bps:String = (ftureData as! NSDictionary).value(forKey: "BPS") as! String;
            self.futureEPS.setValue(self.removeSpecialCharsFromString(text: eps), forKey: self.removeSpecialCharsFromString(text: year));
            self.futureBPS.setValue(self.removeSpecialCharsFromString(text: bps), forKey: self.removeSpecialCharsFromString(text: year))

        }
        self.forwardEpsCompondIncrease = (sqrt((Double((self.futureEPS.value(forKey:"201912") as! String))!)/(Double(self.futureEPS.value(forKey: "201712") as! String))!)-1)*100
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    func toJSON() -> Dictionary <String,Any>! {
        return [
            "name":stockName,
            "code":stockCode,
            "futureEPS":self.futureEPS,
            "futureBPS":self.futureBPS,
            "composeEPSIncreaase":self.forwardEpsCompondIncrease
        ]
    }
}

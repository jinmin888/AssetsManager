//
//  Stock.swift
//  AssetsManager
//
//  Created by min on 12/10/2017.
//  Copyright © 2017 min. All rights reserved.
//

import Foundation

class Stock {
    var currentPer:Double = 0
    var currentPrice:Double = 0
    var historyPrice:[String:Double] = [:]
    var historyEPS:[String:Double] = [:]
    var historyPER:[String:Double] = [:]
    var FutureEPS:[String:Double] = [:]
    var last5yAvgPer:Double = 0
    var forwardEpsCompondIncrease = 0
    var futureEPSIncrease = 0
    var latestUpdateTimestamp = 0
}

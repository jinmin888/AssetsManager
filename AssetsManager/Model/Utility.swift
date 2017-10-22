//
//  Utility.swift
//  AssetsManager
//
//  Created by min on 10/21/17.
//  Copyright © 2017 min. All rights reserved.
//

import Foundation


class Utility {
   static func isWeekend()->Bool{
        let dayOfWeek = Calendar.current.component(.weekday, from: Date())
        if( dayOfWeek == 1 || dayOfWeek == 7){
            return true
        }
        return false
    }
    static func currentDate() -> String {
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyyMMdd"
        return formmater.string(from: Date())
    }
}

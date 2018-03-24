//
//  Date+StringISO.swift
//  GPSwfitObject
//
//  Created by 强新宇 on 2017/10/30.
//  Copyright © 2017年 强新宇. All rights reserved.
//

import Foundation


extension Date {
    func stringWithISOFormat() -> String {
        let formatter = DateFormatter.init()
        formatter.locale = Locale.init(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: self)
    }
    
    
    
    func getTimes() -> (Int, Int, Int, String, String) {
        let dateArr = stringWithISOFormat().components(separatedBy: "T")
        let ymd = dateArr.first ?? ""
        var times = dateArr.last ?? ""
        
        let ymdArr = ymd.components(separatedBy: "-")
        
        if ymdArr.count != 3 {
            return (0,0,0,"","")
        }
        
        let index = times.index(times.startIndex, offsetBy: 5)
        times = String(times[..<index])
        
        
        return (ymdArr[0].intValue(),
                ymdArr[1].intValue() ,
                ymdArr[2].intValue(),
                times,
                ymd + " " + times)
    }
    
    static func getTimeString(timeInterval: UInt64) -> String {
        let date = Date.init(timeIntervalSince1970: TimeInterval(timeInterval) / 1000.0)
        let dateTimes = date.getTimes()
        
        let now = Date()
        let nowTimes = now.getTimes()
        
        if nowTimes.2 - dateTimes.2 == 1 {
            return "昨天"
        } else if nowTimes.2 - dateTimes.2 == 2 {
            return "前天"
        } else if nowTimes.2 - dateTimes.2 > 2 {
            return dateTimes.4
        } else {
            return dateTimes.3
        }
    }
    
    static func getTimeString1(timeInterval: UInt64) -> String {
        let date = Date.init(timeIntervalSince1970: TimeInterval(timeInterval) / 1000.0)
        let dateTimes = date.getTimes()
        
        let now = Date()
        let nowTimes = now.getTimes()
        
        if nowTimes.2 - dateTimes.2 == 1 {
            return "昨天 " + dateTimes.3
        } else if nowTimes.2 - dateTimes.2 == 2 {
            return "前天 " + dateTimes.3
        } else if nowTimes.2 - dateTimes.2 > 2 {
            return dateTimes.4
        } else {
            return dateTimes.3
        }
    }
}

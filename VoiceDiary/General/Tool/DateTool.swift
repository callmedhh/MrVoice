
//
//  DateTool.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/8.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation

class DateTool{
    class func convertDate(date:NSDate) -> NSDate{
        let cal = NSCalendar.currentCalendar()
        let component = cal.components([.Year,.Month,.Day], fromDate: date)
        let newDate = cal.dateFromComponents(component)!
        return newDate
    }
    class func getMonth() -> String {
        let date = NSDate()
        let cal = NSCalendar.currentCalendar()
        let component = cal.components([.Month], fromDate: date)
        let month = component.month
        return month.getTwobitNumber(month)
    }
    class func getDay() -> String {
        let date = NSDate()
        let cal = NSCalendar.currentCalendar()
        let component = cal.components([.Day], fromDate: date)
        let day = component.day
        return day.getTwobitNumber(day)
    }
}
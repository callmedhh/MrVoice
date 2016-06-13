
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
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierChinese)!
        let component = cal.components([.Year,.Month,.Day], fromDate: date)
        let newDate = cal.dateFromComponents(component)!
        return newDate
    }
    class func getMonth() -> Int {
        let date = NSDate()
        let cal = NSCalendar.currentCalendar()
        let component = cal.components([.Month], fromDate: date)
        let month = component.month
        log.info("month\(month)")
        return month
    }
    class func getDay() -> Int {
        let date = NSDate()
        let cal = NSCalendar.currentCalendar()
        let component = cal.components([.Day], fromDate: date)
        let day = component.day
        log.info("day\(day)")
        return day
    }
}
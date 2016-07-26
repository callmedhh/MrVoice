
//
//  DateTool.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/8.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation
class DateTool{
    
    class func convertDateToYearMonthDay(date:NSDate) -> NSDate{
        let cal = NSCalendar.currentCalendar()
        let component = cal.components([.Year,.Month,.Day], fromDate: date)
        let newDate = cal.dateFromComponents(component)!
        return newDate
    }
    
    class func generateDateFromYearAndMonth(year: Int, month: Int, day: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        let date =  cal.dateFromComponents(components)
        return date!
    }
    
}
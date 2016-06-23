
//
//  DateTool.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/8.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation
let monthDes = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Agu","Sep","Oct","Mov","Dec"]
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
    class func getMonthDes() -> String {
        let date = NSDate()
        let cal = NSCalendar.currentCalendar()
        let component = cal.components([.Month], fromDate: date)
        let month = component.month
        return monthDes[month-1]
    }
    class func getDay() -> String {
        let date = NSDate()
        let cal = NSCalendar.currentCalendar()
        let component = cal.components([.Day], fromDate: date)
        let day = component.day
        return day.getTwobitNumber(day)
    }
    class func getDayOfTheWeek(date: NSDate) -> Int {
        let cal = NSCalendar.currentCalendar()
        let component = cal.components(.Weekday, fromDate: date)
        let weekday = component.weekday
        return weekday
    }
    class func getWeekOfTheMonth(date: NSDate) -> Int {
        let cal = NSCalendar.currentCalendar()
        let component = cal.components(.WeekOfMonth, fromDate: date)
        let weekOfMonth = component.weekOfMonth
        return weekOfMonth
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
    class func getDayCountOfMonth(date: NSDate) -> Int {
        let endOfMonth = date.endOfMonth()
        let calendar = NSCalendar.currentCalendar()
        let component = calendar.components(.Day, fromDate: endOfMonth!)
        return component.day
    }
}
//
//  DateExtension.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/21.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation

extension NSDate {
    func startOfMonth() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components([.Year, .Month], fromDate: self) else { return nil }
        comp.to0am()
        return cal.dateFromComponents(comp)!
    }
    
    func endOfMonth() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = NSDateComponents() else { return nil }
        comp.month = 1
        comp.day -= 1
        comp.to0am()
        return cal.dateByAddingComponents(comp, toDate: self.startOfMonth()!, options: [])!
    }
    
    func getMonth() -> Int {
        let cal = NSCalendar.currentCalendar()
        let comp = cal.components([.Month], fromDate: self)
        return comp.month
    }
    
    func getYear() -> Int {
        let cal = NSCalendar.currentCalendar()
        let comp = cal.components([.Year], fromDate: self)
        return comp.year
    }
    
    func getDay() -> Int {
        let cal = NSCalendar.currentCalendar()
        let comp = cal.components([.Day], fromDate: self)
        return comp.day
    }
    
    func getDayCountOfMonth() -> Int {
        let endOfMonth = self.endOfMonth()
        let cal = NSCalendar.currentCalendar()
        let component = cal.components(.Day, fromDate: endOfMonth!)
        return component.day + 1
    }
    
    func getMonthStr() -> String {
        let cal = NSCalendar.currentCalendar()
        let component = cal.components([.Month], fromDate: self)
        let month = component.month
        return month.getTwobitNumber()
    }
    
    func getDayStr() -> String {
        let cal = NSCalendar.currentCalendar()
        let component = cal.components([.Day], fromDate: self)
        let day = component.day
        return day.getTwobitNumber()
    }
    
    func getDayOfTheWeek() -> Int {
        let cal = NSCalendar.currentCalendar()
        let component = cal.components(.Weekday, fromDate: self)
        let weekday = component.weekday
        return weekday
    }
    func getWeekOfTheMonth() -> Int {
        let cal = NSCalendar.currentCalendar()
        let component = cal.components(.WeekOfMonth, fromDate: self)
        let weekOfMonth = component.weekOfMonth
        return weekOfMonth
    }
    
    func getMonthDes() -> String {
        let monthDes = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Agu","Sep","Oct","Mov","Dec"]
        let cal = NSCalendar.currentCalendar()
        let component = cal.components([.Month], fromDate: self)
        let month = component.month
        return monthDes[month-1]
    }

}

internal extension NSDateComponents {
    func to0am() {
        self.hour = 0
        self.minute = 0
        self.second = 0
    }
}
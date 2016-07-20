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
    
}

internal extension NSDateComponents {
    func to0am() {
        self.hour = 0
        self.minute = 0
        self.second = 0
    }
}
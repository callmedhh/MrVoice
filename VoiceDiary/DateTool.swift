
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
}
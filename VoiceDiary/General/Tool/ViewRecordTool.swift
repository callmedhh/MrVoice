//
//  ViewRecordTool.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/21.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation

class ViewRecordTool{
    var dbTool: Database = Database()
    var dailyRecordList: [DailyRecord] = []
    init(){
        dbTool.createTable()
    }
    class func hasRecord(recordModelList:[RecordModel], date: NSDate) -> Bool {
        for item in recordModelList {
            if item.date == date {
                return true
            }
        }
        return false
    }
}
// MARK: - get
extension ViewRecordTool {
    func getAllDailyRecordList(month: Int, year: Int) -> [DailyRecord]{
        var recordList: [DailyRecord] = []
        let startOfMonth = DateTool.generateDateFromYearAndMonth(year, month: month, day: 1)
        let endOfMonth = startOfMonth.endOfMonth()
        let recordModelList = dbTool.selectAllMonthRecordListByRange(startOfMonth, endDateValue: endOfMonth!)
        let weekdayOfmonthStart = DateTool.getDayOfTheWeek(startOfMonth)
        let dayOfTMonth = DateTool.getDayCountOfMonth(startOfMonth)
        let count = weekdayOfmonthStart + dayOfTMonth
        for i in 0..<count{
            if i < weekdayOfmonthStart {
                recordList.append(DailyRecord())
            }else{
                let date = DateTool.generateDateFromYearAndMonth(year, month: month, day: i-weekdayOfmonthStart)
                if ViewRecordTool.hasRecord(recordModelList, date: date) {
                    recordList.append(DailyRecord(isRecordedValue: true, dateValue: date))
                }else {
                    recordList.append(DailyRecord(isRecordedValue: false, dateValue: date))
                }
            }
        }
        return recordList
    }
    
}

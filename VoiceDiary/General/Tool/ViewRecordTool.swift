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
    class func getRecordByDate(recordModelList:[RecordModel], date: NSDate) -> RecordModel?{
        for item in recordModelList {
            if item.date == date {
                return item
            }
        }
        return nil
    }
}
// MARK: - get
extension ViewRecordTool {
    func getMonthDailyRecordList(month month: Int, year: Int) -> [DailyRecord]{
        var recordList: [DailyRecord] = []
        let startOfMonth = DateTool.generateDateFromYearAndMonth(year, month: month, day: 1)
        let endOfMonth = startOfMonth.endOfMonth()
        let recordModelList = dbTool.selectAllMonthRecordListByRange(startOfMonth, endDateValue: endOfMonth!)
        let daysOfTMonth = DateTool.getDayCountOfMonth(startOfMonth)
        for i in 0..<daysOfTMonth{
            let date = DateTool.generateDateFromYearAndMonth(year, month: month, day: i+1)
            if ViewRecordTool.hasRecord(recordModelList, date: date) {
                if let recordModel = ViewRecordTool.getRecordByDate(recordModelList, date: date){
                        recordList.append(DailyRecord(isRecordedValue: true, dateValue: date,recordModelValue: recordModel))
                }
                
            }else {
                recordList.append(DailyRecord(isRecordedValue: false, dateValue: date))
            }
        }
        return recordList
    }
    
    func getRecordByTime(day: Int, month: Int, year: Int) -> DailyRecord {
        let date = DateTool.generateDateFromYearAndMonth(year, month: month, day: day)
        
        if let record = dbTool.selectRecordByDate(date) {
            return DailyRecord(isRecordedValue: true, dateValue: date, recordModelValue: record)
        }else{
            return DailyRecord(isRecordedValue: false, dateValue: date)
        }
    }
}

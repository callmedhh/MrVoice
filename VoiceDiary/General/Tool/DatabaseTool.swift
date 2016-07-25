//
//  DatabaseTool.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/8.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation
import SQLite

let id = Expression<Int>("id")
let date = Expression<NSDate>("date")
let filename = Expression<String?>("filename")
let mood = Expression<Int>("mood")

let database = Database()

class Database {
    let path = FilePathTool.getDocumentsDirectory()
    
    lazy private var db: Connection = {
       return try! Connection("\(self.path)/db.sqlite3")
    }()
    
    private var record = Table("record")
    
    init () {
        createTable()
    }
    
    func createTable() -> Table{
        do{
            try db.run(record.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(date)
                t.column(filename)
                t.column(mood)
            }))
        } catch {
        }
        return record
    }
    
    func addRecord(fileName fileName: String, moodValue: Int){
        let nowDate = NSDate()
        let newDate = DateTool.convertDateToYearMonthDay(nowDate)
        let insert = record.insert(date <- newDate, filename <- fileName, mood <- moodValue)
        try! db.run(insert)
    }
    
    func updateRecord(idValue: Int, dateValue: NSDate, recordUrlValue: String, moodValue: Int){
        let recordRow = record.filter(id == idValue)
        let newDate = DateTool.convertDateToYearMonthDay(dateValue)
        try! db.run(recordRow.update(date <- newDate, filename <- recordUrlValue, mood <- moodValue))
    }
    
    func deleteRecord(deleteId deleteId:Int){
        let recordRow = record.filter(id == deleteId)
        try! db.run(recordRow.delete())
    }
    
    func selectRecordByDate(dateValue: NSDate) -> RecordModel?{
        var recordList = [RecordModel]()
        let query = record.filter(date == dateValue)
        
        for recordItem in try! db.prepare(query) {
            let recordModel = RecordModel(date: recordItem[date], filename:recordItem[filename]!, mood: recordItem[mood])
            recordList.append(recordModel)
        }
        if recordList.count == 0 {
            return nil
        } else {
            return recordList[0]
        }
        
    }
    
    func selectALLRecordList() -> [RecordModel]{
        var recordList = [RecordModel]()
        for recordItem in try! db.prepare(record) {
            let recordModel = RecordModel(date: recordItem[date], filename:recordItem[filename]!, mood: recordItem[mood])
            recordList.append(recordModel)
        }
        return recordList
    }
    
    //得到该日期范围内所有的记录
    func selectAllMonthRecordListByRange(startDateValue: NSDate, endDateValue: NSDate) -> [RecordModel] {
        var recordList = [RecordModel]()
        
        let query = record.filter(date >= startDateValue && date <= endDateValue)
        for recordItem in try!db.prepare(query) {
            let recordModel = RecordModel(date: recordItem[date], filename:recordItem[filename]!, mood: recordItem[mood])
            recordList.append(recordModel)
        }
        return recordList
    }
}
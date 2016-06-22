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
let recordUrl = Expression<String?>("recordUrl")
let mood = Expression<Int>("mood")

class Database{
    let path = FilePathTool.getDocumentsDirectory()
    
    lazy private var db: Connection = {[unowned self ] in
       return try! Connection("\(self.path)/db.sqlite3")
    }()
    
    private var record = Table("record")
    
    func createTable() -> Table{
        do{
            try db.run(record.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(date)
                t.column(recordUrl)
                t.column(mood)
            }))
        }catch{
            print("Error create table record")
        }
        return record
    }
    
    func addRecord(fileUrl fileUrl: String, moodValue: Int){
        let nowDate = NSDate()
        let newDate = DateTool.convertDate(nowDate)
        let insert = record.insert(date <- newDate, recordUrl <- fileUrl, mood <- moodValue)
        print("newDate\(newDate)")
        try! db.run(insert)
    }
    
    func updateRecord(idValue: Int, dateValue: NSDate, recordUrlValue: String, moodValue: Int){
        let recordRow = record.filter(id == idValue)
        let newDate = DateTool.convertDate(dateValue)
        try! db.run(recordRow.update(date <- newDate, recordUrl <- recordUrlValue, mood <- moodValue))
    }
    
    func deleteRecord(deleteId deleteId:Int){
        let recordRow = record.filter(id == deleteId)
        try! db.run(recordRow.delete())
    }
    
    func selectRecordListByDate(dateValue: NSDate) -> [RecordModel]{
        var recordList = [RecordModel]()
        let query = record.filter(date == dateValue)
        
        for recordItem in try! db.prepare(query) {
            let recordModel = RecordModel(dateValue: recordItem[date], recordUrlValue:recordItem[recordUrl]!, moodValue: recordItem[mood])
            recordList.append(recordModel)
        }
        return recordList
    }
    
    func selectALLRecordList() -> [RecordModel]{
        var recordList = [RecordModel]()
        for recordItem in try! db.prepare(record) {
            let recordModel = RecordModel(dateValue: recordItem[date], recordUrlValue:recordItem[recordUrl]!, moodValue: recordItem[mood])
            recordList.append(recordModel)
        }
        return recordList
    }
    
    //得到该日期范围内所有的记录
    func selectAllMonthRecordListByRange(startDateValue: NSDate, endDateValue: NSDate) -> [RecordModel] {
        var recordList = [RecordModel]()
        
        let query = record.filter(date >= startDateValue && date <= endDateValue)
        for recordItem in try!db.prepare(query) {
            let recordModel = RecordModel(dateValue: recordItem[date], recordUrlValue:recordItem[recordUrl]!, moodValue: recordItem[mood])
            recordList.append(recordModel)
        }
        return recordList
    }
}
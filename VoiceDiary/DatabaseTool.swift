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
            }))
        }catch{
            print("Error create table record")
        }
        return record
    }
    
    func addRecord(fileUrl fileUrl: String){
        let nowDate = NSDate()
        let newDate = DateTool.convertDate(nowDate)
        let insert = record.insert(date <- newDate ,recordUrl <- fileUrl)
        try! db.run(insert)
    }
    
    func updateRecord(idValue: Int, dateValue: NSDate, recordUrlValue: String){
        let recordRow = record.filter(id == idValue)
        try! db.run(recordRow.update(date <- dateValue, recordUrl <- recordUrlValue))
    }
    
    func deleteRecord(deleteId deleteId:Int){
        let recordRow = record.filter(id == deleteId)
        try! db.run(recordRow.delete())
    }
    
    func selectRecordListByDate(dateValue: NSDate) -> [RecordModel]{
        var recordList = [RecordModel]()
        let query = record.filter(date == dateValue)
        
        for recordItem in try! db.prepare(query) {
            let recordModel = RecordModel(dateValue: recordItem[date], recordUrlValue:recordItem[recordUrl]!)
            recordList.append(recordModel)
        }
        return recordList
    }
    
    func selectALLRecordList() -> [RecordModel]{
        var recordList = [RecordModel]()
        for recordItem in try! db.prepare(record) {
            let recordModel = RecordModel(dateValue: recordItem[date], recordUrlValue:recordItem[recordUrl]!)
            recordList.append(recordModel)
        }
        return recordList
    }
}
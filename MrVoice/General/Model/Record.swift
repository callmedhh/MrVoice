//
//  DailyRecord.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/20.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit
import SQLite

struct Record {
    struct Date {
        var year: Int
        var month: Int
        var day: Int
    }
    var date: Date
    var filename: String
    var mood: Mood
    
    init (date dateValue: NSDate? = nil, filename: String, mood: Mood) {
        let nsdate = dateValue ?? NSDate()
        let date = Date(year: nsdate.getYear(), month: nsdate.getMonth(), day: nsdate.getDay())
        self.init(date: date, filename: filename, mood: mood)
    }
    
    init (date: Date, filename: String, mood: Mood) {
        self.date = date
        self.filename = filename
        self.mood = mood
    }
}

extension DB.Record {
    static func addRecord(record: Record){
        let date = record.date
        let insert = table.insert([
            year        <- date.year,
            month       <- date.month,
            day         <- date.day,
            filename    <- record.filename,
            mood        <- record.mood.rawValue])
        try! DB.db.run(insert)
    }
    
    static func selectRecords(year yearValue: Int? = nil, month monthValue: Int? = nil, day dayValue: Int? = nil) -> [Record] {
        var query = table
        if let v = yearValue {
            query = query.filter(year == v)
        }
        if let v = monthValue {
            query = query.filter(month == v)
        }
        if let v = dayValue {
            query = query.filter(day == v)
        }
        
        let selectItems = try! DB.db.prepare(query)
        let records: [Record] = selectItems.map({ item in
            let date = Record.Date(year: item[year], month: item[month], day: item[day])
            return Record(date: date, filename: item[filename], mood: Mood(rawValue: item[mood])!)
        })
        return records
    }
}
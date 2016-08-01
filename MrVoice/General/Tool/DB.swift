//
//  DatabaseTool.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/8.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation
import SQLite

struct DB {
    struct Record {
        static let table = Table("record")
        static let pid = Expression<Int>("pid")
        static let year = Expression<Int>("year")
        static let month = Expression<Int>("month")
        static let day = Expression<Int>("day")
        static let filename = Expression<String>("filename")
        static let mood = Expression<Int>("mood")
    }
    

    static let db: Connection = try! Connection("\(FilePath.documentDirectory())/voice.sqlite3")

    static func setup() {
        do {
            try db.run(Record.table.create(ifNotExists: true, block: { t in
                t.column(Record.pid, primaryKey: true)
                t.column(Record.year)
                t.column(Record.month)
                t.column(Record.day)
                t.column(Record.filename)
                t.column(Record.mood)
            }))
        } catch {
            log.error("database error")
        }
    }
}
//
//  DailyRecord.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/20.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation
class DailyRecord {
    var isRecorded: Bool
    var date: NSDate
    var recordModel: RecordModel?
    init(){
        isRecorded = false
        date = NSDate()
        recordModel = nil
    }
    init(isRecordedValue: Bool, dateValue: NSDate){
        isRecorded = isRecordedValue
        date = dateValue
    }
    init(isRecordedValue: Bool, dateValue: NSDate, recordModelValue: RecordModel) {
        isRecorded = isRecordedValue
        date = dateValue
        recordModel = recordModelValue
    }
}
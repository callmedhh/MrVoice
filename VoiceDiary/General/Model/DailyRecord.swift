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
    init(){
        isRecorded = false
        date = NSDate()
    }
    init(isRecordedValue: Bool, dateValue: NSDate){
        isRecorded = isRecordedValue
        date = dateValue
    }
}
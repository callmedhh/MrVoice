//
//  RecordModel.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/9.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation

class RecordModel{
    var date: NSDate
    var recordUrl: String
    var mood: Int
    init(dateValue: NSDate, recordUrlValue: String, moodValue: Int){
        self.date = dateValue
        self.recordUrl = recordUrlValue
        self.mood = moodValue
    }
}
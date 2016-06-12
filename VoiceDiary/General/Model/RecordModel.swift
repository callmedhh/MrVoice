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
    init(dateValue: NSDate, recordUrlValue: String){
        self.date = dateValue
        self.recordUrl = recordUrlValue
    }
}
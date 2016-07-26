//
//  MoodEnumModel.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/21.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

enum Mood: Int {
    case Happy = 0
    case Flat
    case Sad
    
    func color() -> UIColor {
        switch self {
        case .Happy:
            return UIColor.Calendar.happy
        case .Flat:
            return UIColor.Calendar.flat
        case .Sad:
            return UIColor.Calendar.sad
        }
    }
}
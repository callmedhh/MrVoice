//
//  IntExtension.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/13.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation
extension Int{
    func getTwobitNumber(number: Int) -> String {
        if number>0 && number < 10 {
            return "0\(number)"
        }else{
            return "\(number)"
        }
    }
}
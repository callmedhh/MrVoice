//
//  IntExtension.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/13.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation
extension Int{
    func getTwobitNumber() -> String {
        if self>0 && self < 10 {
            return "0\(self)"
        }else{
            return "\(self)"
        }
    }
}
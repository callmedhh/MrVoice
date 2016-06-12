//
//  StringExtension.swift
//  VoiceDiary
//
//  Created by why on 6/12/16.
//  Copyright © 2016 Lemur. All rights reserved.
//

import Foundation

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathComponent(path)
    }
}
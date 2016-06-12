//
//  FilePathTool.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/9.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation
class FilePathTool{
    class func getDocumentsDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
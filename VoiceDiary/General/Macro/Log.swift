//
//  Log.swift
//  VoiceDiary
//
//  Created by why on 6/12/16.
//  Copyright © 2016 Lemur. All rights reserved.
//

import SwiftyBeaver

let log = SwiftyBeaver.self

func initLog() {
    let console = ConsoleDestination()
    log.addDestination(console)
}
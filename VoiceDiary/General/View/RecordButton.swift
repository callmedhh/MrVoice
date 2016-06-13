//
//  RecordButton.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/13.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit
import SwiftHEXColors

class RecordButton: UIButton {
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, UIColor(white: 1, alpha: 0.02).CGColor)
        CGContextAddEllipseInRect(context, CGRectMake(0,0,200,200))
        CGContextFillPath(context)

        CGContextSetFillColorWithColor(context, UIColor(white: 1, alpha: 0.04).CGColor)
        CGContextAddEllipseInRect(context, CGRectMake(20,20,160,160))
        CGContextFillPath(context)
        
        CGContextSetFillColorWithColor(context, UIColor(white: 1, alpha: 0.08).CGColor)
        CGContextAddEllipseInRect(context, CGRectMake(40,40,120,120))
        CGContextFillPath(context)
        
        CGContextSetFillColorWithColor(context, UIColor(hexString: "#fee140")!.CGColor)
        CGContextAddEllipseInRect(context, CGRectMake(60,60,80,80))
        CGContextFillPath(context)

    }
}

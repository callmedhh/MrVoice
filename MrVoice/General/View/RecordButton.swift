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
    
    enum State {
        case Idle
        case Recording
    }
    
    var currentState: State = State.Idle
    override func drawRect(rect: CGRect) {
        log.debug(currentState)
        if currentState == State.Idle {
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
        }else if currentState == State.Recording{
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
            
            CGContextSetStrokeColorWithColor(context, UIColor(hexString: "#fee140")!.CGColor)
            CGContextSetLineWidth(context, 1.5)
            CGContextAddEllipseInRect(context, CGRectMake(60,60,80,80))
            CGContextStrokePath(context)
        
            CGContextSetFillColorWithColor(context, UIColor(hexString: "#fee140", alpha: 0.2)!.CGColor)
            CGContextAddEllipseInRect(context, CGRectMake(61.5, 61.5, 77, 77))
            CGContextFillPath(context)
        
            CGContextSetFillColorWithColor(context,UIColor(hexString: "#fee140")!.CGColor)
            let clippath = UIBezierPath(roundedRect: CGRectMake(80,80,40,40), cornerRadius: 2.0).CGPath
            CGContextAddPath(context, clippath)
            CGContextClosePath(context);
            CGContextFillPath(context);
        }
    
    }
}

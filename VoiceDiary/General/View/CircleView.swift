//
//  CircleView.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/21.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

class CircleView: UIView {
    var circleColor: UIColor = UIColor.grayColor()
    override func drawRect(rect: CGRect) {
        let width = frame.size.width
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context,circleColor.CGColor)
        let rectangle = CGRectMake(0,0,width,width)
        CGContextAddEllipseInRect(context, rectangle)
        CGContextFillPath(context)
    }
    
    
}

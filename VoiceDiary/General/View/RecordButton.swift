//
//  RecordButton.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/13.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

class RecordButton: UIButton {
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextMoveToPoint(context, 30, 30)
        CGContextAddLineToPoint(context, 300, 400)
        CGContextStrokePath(context)
    }
}

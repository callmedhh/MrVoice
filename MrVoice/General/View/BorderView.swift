//
//  BorderView.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/14.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit
import SwiftHEXColors

class BorderView: UIView {
    var yellowLayer: CAShapeLayer!
    var grayLayer: CAShapeLayer!
    let duration: NSTimeInterval = 10.0
    
    func animate() {
        drawGrayLine()
        animateYellowLine()
    }
    
    private func animateYellowLine() {
        
        let frameWidth = self.frame.size.width
        let frameHeight = self.frame.size.height
        
        self.backgroundColor = UIColor.clearColor()
        
        let lineWidth = CGFloat(5)
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: lineWidth/2, y: frameHeight * 2 / 3))
        path.addLineToPoint(CGPoint(x: lineWidth/2, y: frameHeight-lineWidth/2))
        path.addLineToPoint(CGPoint(x: frameWidth-lineWidth/2, y:frameHeight-lineWidth/2))
        path.addLineToPoint(CGPoint(x: frameWidth-lineWidth/2, y:lineWidth/2))
        path.addLineToPoint(CGPoint(x: lineWidth/2, y: lineWidth/2))
        path.addLineToPoint(CGPoint(x: lineWidth/2, y: frameHeight * 2 / 3))
        // Setup the CAShapeLayer with the path, colors, and line width
        yellowLayer = CAShapeLayer()
        yellowLayer.path = path.CGPath
        yellowLayer.fillColor = UIColor.clearColor().CGColor
        yellowLayer.strokeColor = UIColor(hexString: "#fee140")!.CGColor
        yellowLayer.lineWidth = lineWidth;
        
        // Don't draw the circle initially
        yellowLayer.strokeEnd = 0.0

        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        yellowLayer.strokeEnd = 1.0
        
        // Do the actual animation
        yellowLayer.addAnimation(animation, forKey: "animateYellowLine")
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(yellowLayer)
    }
    
     func drawGrayLine() {
        let frameWidth = self.frame.size.width
        let frameHeight = self.frame.size.height
        self.backgroundColor = UIColor.clearColor()
        
        let lineWidth = CGFloat(5)
        let grayPath = UIBezierPath()
        grayPath.moveToPoint(CGPoint(x: lineWidth/2, y: lineWidth/2))
        grayPath.addLineToPoint(CGPoint(x: lineWidth/2, y: frameHeight-lineWidth/2))
        grayPath.addLineToPoint(CGPoint(x: frameWidth-lineWidth/2, y:frameHeight-lineWidth/2))
        grayPath.addLineToPoint(CGPoint(x: frameWidth-lineWidth/2, y:lineWidth/2))
        grayPath.addLineToPoint(CGPoint(x: lineWidth/2, y: lineWidth/2))
      
        grayLayer = CAShapeLayer()
        grayLayer.path = grayPath.CGPath
        grayLayer.fillColor = UIColor.clearColor().CGColor
        grayLayer.strokeColor = UIColor(hexString: "#2d3133")!.CGColor
        grayLayer.lineWidth = lineWidth;
        grayLayer.strokeEnd = 1.0
        
        layer.addSublayer(grayLayer)
    }
    
    func cancelAnimate(){
        grayLayer.removeFromSuperlayer()
        yellowLayer.removeFromSuperlayer()
    }
    
}

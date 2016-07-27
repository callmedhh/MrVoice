//
//  RecordButton.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/13.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit
import SwiftHEXColors

@objc
protocol RecordButtonHandler {
    func stateChanged(state: RecordButton.State)
}

class RecordButton: UIButton {
    @objc
    enum State: Int {
        case Idle
        case Recording
        case Disabled
    }
    var currentState: State = State.Idle
    var progress = 0
    let alphas: [CGFloat] = [0.02, 0.04, 0.08]
    var layerCount:  Int {
        get {
            return alphas.count
        }
    }
    
    @IBOutlet var delegate: RecordButtonHandler!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(pressed), forControlEvents: .TouchUpInside)
    }
}

extension RecordButton {
    func pressed(sender: UIButton) {
        switch currentState {
        case .Idle:
            currentState = .Recording
            
            progress = 0
            setNeedsDisplay()
            UIView.animateWithDuration(1, animations: {
            }, completion: { _ in
                self.progress = 1
                self.setNeedsDisplay()
            })
        case .Recording:
            currentState = .Idle
            setNeedsDisplay()
        default:
            return
        }
    }
}


// MARK: - Private
extension RecordButton {
    private func addLayer(index: Int, width: CGFloat, spacing: CGFloat) {
        let context = UIGraphicsGetCurrentContext()
        let margin = spacing * CGFloat(index)
        let size = width - margin * 2
        CGContextSetFillColorWithColor(context, UIColor(white: 1, alpha: alphas[index]).CGColor)
        CGContextAddEllipseInRect(context, CGRectMake(margin, margin, size, size))
        CGContextFillPath(context)
    }
    
    private func drawIdle() {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.RecordButton.mainColor.CGColor)
        CGContextAddEllipseInRect(context, CGRectMake(60, 60, 80, 80))
        CGContextFillPath(context)
        for i in 0..<layerCount {
            addLayer(i, width: 200, spacing: 20)
        }
    }
    
    private func drawRecording() {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.RecordButton.mainColor.CGColor)
        CGContextSetLineWidth(context, 1.5)
        CGContextAddEllipseInRect(context, CGRectMake(60, 60, 80, 80))
        CGContextStrokePath(context)
        
        CGContextSetFillColorWithColor(context, UIColor.RecordButton.mainColor.colorWithAlphaComponent(0.2).CGColor)
        CGContextAddEllipseInRect(context, CGRectMake(61.5, 61.5, 77, 77))
        CGContextFillPath(context)
        
        CGContextSetFillColorWithColor(context,UIColor.RecordButton.mainColor.CGColor)
        CGContextAddPath(context, UIBezierPath(roundedRect: CGRectMake(80,80,40,40), cornerRadius: 2.0).CGPath)
        CGContextClosePath(context);
        CGContextFillPath(context);
        
        for i in 0..<progress {
            addLayer(layerCount - 1 - i, width: 200, spacing: 20)
        }
    }
    
    private func drawDisabled() {
        
    }
}

// MARK: - Override
extension RecordButton {
    override func drawRect(rect: CGRect) {
        log.debug(progress)
        switch currentState {
        case .Idle:
            drawIdle()
        case .Recording:
            drawRecording()
        case .Disabled:
            drawDisabled()
        }
    }
}

//
//  ProgressView.swift
//  MrVoice
//
//  Created by why on 7/29/16.
//  Copyright © 2016 Lemur. All rights reserved.
//

import UIKit
import Async

class ProgressView: UIView {
    var backgroundLayer = CAShapeLayer()
    var foregroundLayer = CAShapeLayer()
    var progress: CGFloat = 0 {
        didSet {
            updateLayers()
        }
    }
    //从 xib 加载 UIView 调用该方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(foregroundLayer)
    }
    override func layoutSubviews() {
        updateLayers()
    }
    
    private func updateLayers() {
        backgroundLayer.fillColor = UIColor.ProgressView.backgroundColor.CGColor
        backgroundLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height/2).CGPath
        foregroundLayer.fillColor = UIColor.General.mainColor.CGColor
        foregroundLayer.path = UIBezierPath(roundedRect: CGRectMake(0, 0, bounds.width * progress, bounds.height), cornerRadius: self.bounds.height/2).CGPath
    }
}
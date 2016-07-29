//
//  RecordButton.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/13.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit
import SwiftHEXColors
import Async

protocol RecordButtonHandler {
    func stateChanged(state: RecordButton.State)
}

class RecordButton: UIButton {
    enum State: Int {
        case Idle
        case Recording
        case Disabled
    }
    var currentState: State = State.Idle
    var delegate: RecordButtonHandler?
    let spacing = 17
    lazy var radius: CGFloat = {
        return CGFloat(Screen.width * 0.1)
    }()
    
    lazy var idleLayer: CAShapeLayer = {
        let margin = self.bounds.width / 2 - self.radius
        let path = UIBezierPath(ovalInRect: CGRectMake(margin, margin, self.radius*2, self.radius*2))
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.RecordButton.mainColor.CGColor
        layer.path = path.CGPath
        layer.shadowColor = layer.fillColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        return layer
    }()
    lazy var recordingLayer: CAShapeLayer = {
        let margin = self.bounds.width / 2 - self.radius
        let path = UIBezierPath(ovalInRect: CGRectMake(margin, margin, self.radius*2, self.radius*2))
        
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.strokeColor = UIColor.RecordButton.mainColor.CGColor
        layer.fillColor = UIColor.RecordButton.mainColor.colorWithAlphaComponent(0.2).CGColor
        layer.path = path.CGPath
        layer.shadowColor = layer.fillColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        let subLayer = CAShapeLayer()
        let subSize = self.radius * 2 * 0.44
        let subMargin = (self.bounds.width - subSize) / 2
        subLayer.path = UIBezierPath(roundedRect: CGRect(x: subMargin, y: subMargin, width: subSize, height: subSize), cornerRadius: 3).CGPath
        subLayer.fillColor = UIColor.RecordButton.mainColor.CGColor
        layer.addSublayer(subLayer)
        return layer
    }()
    lazy var backgroundLayers: [CAShapeLayer] = {
        let layers = [CAShapeLayer(), CAShapeLayer(), CAShapeLayer()]
        let alphas:[CGFloat] = [0.02, 0.04, 0.08]
        let width = self.bounds.width
        for (i, layer) in layers.enumerate() {
            let radius = self.radius + CGFloat(self.spacing * (alphas.count - i))
            let margin = width / 2 - radius
            let path = UIBezierPath(ovalInRect: CGRectMake(margin, margin, radius*2, radius*2))
            layer.fillColor = UIColor(white: 1, alpha: alphas[i]).CGColor
            layer.path = path.CGPath
        }
        return layers
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(pressed), forControlEvents: .TouchUpInside)
        setupLayers()
    }
}

// MARK: - Public
extension RecordButton {
    func pressed(sender: UIButton) {
        switch currentState {
        case .Idle:
            currentState = .Recording
            idleLayer.removeFromSuperlayer()
            layer.addSublayer(recordingLayer)
            
            let fadeAnimation = CABasicAnimation(keyPath: "opacity")
            fadeAnimation.fromValue = 1.0
            fadeAnimation.toValue = 0.0
            fadeAnimation.duration = 1.2
            fadeAnimation.repeatCount = Float(Int.max)
            
            self.backgroundLayers[2].addAnimation(fadeAnimation, forKey: "FadeAnimation")
            Async.main(after: 0.2, block: {
                self.backgroundLayers[1].addAnimation(fadeAnimation, forKey: "FadeAnimation")
                Async.main(after: 0.2, block: {
                    self.backgroundLayers[0].addAnimation(fadeAnimation, forKey: "FadeAnimation")
                })
            })
        case .Recording:
            currentState = .Idle
            recordingLayer.removeFromSuperlayer()
            layer.addSublayer(idleLayer)
            for layer in backgroundLayers {
                layer.removeAllAnimations()
            }
        default:
            return
        }
    }
}


// MARK: - Private
extension RecordButton {
    private func setupLayers() {
        for i in backgroundLayers {
            layer.addSublayer(i)
        }
        layer.addSublayer(idleLayer)
    }
}
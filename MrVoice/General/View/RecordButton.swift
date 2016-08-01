//
//  RecordButton.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/13.
//  Copyright © 2016年 Lemur. All rights reserved.
//

// TODO: substract layers
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
    var currentState: State = .Idle {
        didSet {
            switch currentState {
            case .Idle:
                recordingLayer.removeFromSuperlayer()
                disabledLayer.removeFromSuperlayer()
                layer.addSublayer(idleLayer)
                for layer in backgroundLayers {
                    layer.removeAllAnimations()
                }
            case .Recording:
                idleLayer.removeFromSuperlayer()
                disabledLayer.removeFromSuperlayer()
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
            case .Disabled:
                idleLayer.removeFromSuperlayer()
                recordingLayer.removeFromSuperlayer()
                layer.addSublayer(disabledLayer)
                for layer in backgroundLayers {
                    layer.removeAllAnimations()
                }
            }
            delegate?.stateChanged(currentState)
        }
    }
    var delegate: RecordButtonHandler?
    var spacing: CGFloat {
        get {
            return CGFloat(self.bounds.width * 0.09)
        }
    }
    var radius: CGFloat {
        get {
            return CGFloat(self.bounds.width * 0.22)
        }
    }
    
    var idleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.General.mainColor.CGColor
        layer.shadowColor = layer.fillColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        return layer
    }()
    var recordingLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.strokeColor = UIColor.General.mainColor.CGColor
        layer.fillColor = UIColor.General.mainColor.colorWithAlphaComponent(0.2).CGColor
        layer.shadowColor = layer.fillColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        let subLayer = CAShapeLayer()
        subLayer.fillColor = UIColor.General.mainColor.CGColor
        layer.addSublayer(subLayer)
        return layer
    }()
    var disabledLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.General.mainColor.colorWithAlphaComponent(0.38).CGColor
        return layer
    }()
    var backgroundLayers: [CAShapeLayer] = {
        let layers = [CAShapeLayer(), CAShapeLayer(), CAShapeLayer()]
        let alphas:[CGFloat] = [0.02, 0.04, 0.08]
        for (i, layer) in layers.enumerate() {
            layer.fillColor = UIColor(white: 1, alpha: alphas[i]).CGColor
        }
        return layers
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(pressed), forControlEvents: .TouchUpInside)
        for i in backgroundLayers {
            layer.addSublayer(i)
        }
        layer.addSublayer(idleLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin = bounds.width / 2 - self.radius
        let path = UIBezierPath(ovalInRect: CGRectMake(margin, margin, self.radius*2, self.radius*2)).CGPath
        idleLayer.path = path
        recordingLayer.path = path
        disabledLayer.path = path
        
        let subLayer = recordingLayer.sublayers![0] as! CAShapeLayer
        let subSize = self.radius * 2 * 0.44
        let subMargin = (self.bounds.width - subSize) / 2
        subLayer.path = UIBezierPath(roundedRect: CGRect(x: subMargin, y: subMargin, width: subSize, height: subSize), cornerRadius: 3).CGPath
        for (i, layer) in backgroundLayers.enumerate() {
            let radius = self.radius + self.spacing * CGFloat(backgroundLayers.count - i)
            let margin = bounds.width / 2 - radius
            layer.path = UIBezierPath(ovalInRect: CGRectMake(margin, margin, radius*2, radius*2)).CGPath
        }
    }
}

// MARK: - Public
extension RecordButton {
    func pressed(sender: UIButton) {
        switch currentState {
        case .Idle:
            currentState = .Recording
        case .Recording:
            currentState = .Idle
        default:
            break
        }
    }
}


// MARK: - Private
extension RecordButton {
}
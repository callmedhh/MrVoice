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
        case Playing
        case Paused
    }
    var currentState: State = .Idle {
        didSet {
            for layer in mainLayers {
                layer.1.removeFromSuperlayer()
            }
            for layer in backgroundLayers {
                layer.removeAllAnimations()
            }
            layer.addSublayer(mainLayers[currentState]!)
            switch currentState {
            case .Recording,
                 .Playing:
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
            default:
                break
            }
            delegate.stateChanged(currentState)
        }
    }
    
    var delegate: RecordButtonHandler!
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
    
    var mainLayers: [State: CAShapeLayer] = {
        var layers = [State: CAShapeLayer]()
        
        layers[State.Idle] = {
            let layer = CAShapeLayer()
            layer.fillColor = UIColor.General.mainColor.CGColor
            layer.shadowColor = layer.fillColor
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.4
            layer.shadowOffset = CGSize(width: 0, height: 0)
            return layer
        }()
        layers[State.Recording] = {
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
        layers[State.Disabled] = {
            let layer = CAShapeLayer()
            layer.fillColor = UIColor.General.mainColor.colorWithAlphaComponent(0.38).CGColor
            return layer
        }()
        layers[State.Playing] = {
            let layer = CAShapeLayer()
            layer.fillColor = UIColor.General.mainColor.CGColor
            layer.shadowColor = layer.fillColor
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.4
            layer.shadowOffset = CGSize(width: 0, height: 0)
            
            let subLayer = CAShapeLayer()
            subLayer.lineWidth = 3
            subLayer.strokeColor = UIColor.RecordButton.strokeColor.CGColor
            subLayer.fillColor = UIColor.clearColor().CGColor
            layer.addSublayer(subLayer)
            return layer
        }()
        layers[State.Paused] = {
            let layer = CAShapeLayer()
            layer.fillColor = UIColor.General.mainColor.CGColor
            layer.shadowColor = layer.fillColor
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.4
            layer.shadowOffset = CGSize(width: 0, height: 0)
            
            let subLayer = CAShapeLayer()
            subLayer.lineWidth = 3
            subLayer.strokeColor = UIColor.RecordButton.strokeColor.CGColor
            subLayer.fillColor = UIColor.clearColor().CGColor
            layer.addSublayer(subLayer)
            return layer
        }()
        return layers
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
        layer.addSublayer(mainLayers[State.Idle]!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin = bounds.width / 2 - self.radius
        let path = UIBezierPath(ovalInRect: CGRectMake(margin, margin, self.radius*2, self.radius*2)).CGPath
        
        for kv in mainLayers {
            let layer = kv.1
            layer.path = path
            switch kv.0 {
            case .Recording:
                let subLayer = layer.sublayers![0] as! CAShapeLayer
                let subSize = radius * 2 * 0.44
                let subMargin = (self.bounds.width - subSize) / 2
                subLayer.path = UIBezierPath(roundedRect: CGRect(x: subMargin, y: subMargin, width: subSize, height: subSize), cornerRadius: 3).CGPath
            case .Playing:
                let subLayer = layer.sublayers![0] as! CAShapeLayer
                let path = UIBezierPath()
                let margin = bounds.width / 2 - radius
                let lx = radius * 0.80
                let rx = radius * 2 - lx
                let ty = radius * 0.66
                let by = radius * 2 - ty
                path.moveToPoint(CGPoint(x: margin+lx, y: margin+ty))
                path.addLineToPoint(CGPoint(x: margin+lx, y: margin+by))
                path.moveToPoint(CGPoint(x: margin+rx, y: margin+ty))
                path.addLineToPoint(CGPoint(x: margin+rx, y: margin+by))
                path.closePath()
                subLayer.path = path.CGPath
            case .Paused:
                let subLayer = layer.sublayers![0] as! CAShapeLayer
                let path = UIBezierPath()
                let margin = bounds.width / 2 - radius
                let lx = radius * 0.85
                let rx = radius * 1.33
                let ty = radius * 0.66
                let by = radius * 2 - ty
                path.moveToPoint(CGPoint(x: margin+lx, y: margin+ty))
                path.addLineToPoint(CGPoint(x: margin+lx, y: margin+by))
                path.addLineToPoint(CGPoint(x: margin+rx, y: margin+(ty+by)/2))
                path.closePath()
                subLayer.path = path.CGPath
            default:
                break
            }
        }

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
        case .Playing:
            currentState = .Paused
        case .Paused:
            currentState = .Playing
        default:
            break
        }
    }
}


// MARK: - Private
extension RecordButton {
}
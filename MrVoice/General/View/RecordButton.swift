//
//  RecordButton.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/13.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit
import SwiftHEXColors

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
    let spacing = 20
    lazy var idleLayer: CAShapeLayer = {
        let width = self.bounds.width
        let margin = CGFloat(self.backgroundLayers.count * self.spacing)
        let radius = width / 2 - margin
        let path = UIBezierPath(ovalInRect: CGRectMake(margin, margin, radius*2, radius*2))
        
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
        let width = self.bounds.width
        let margin = CGFloat(self.backgroundLayers.count * self.spacing)
        let radius = width / 2 - margin
        let path = UIBezierPath(ovalInRect: CGRectMake(margin, margin, radius*2, radius*2))
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.redColor().CGColor
        layer.path = path.CGPath
        layer.shadowColor = layer.fillColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        return layer
    }()
    lazy var backgroundLayers: [CAShapeLayer] = {
        let layers = [CAShapeLayer(), CAShapeLayer(), CAShapeLayer()]
        let alphas:[CGFloat] = [0.02, 0.04, 0.08]
        let width = self.bounds.width
        
        for (i, layer) in layers.enumerate() {
            let margin = CGFloat(i * self.spacing)
            let radius = width / 2 - margin
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
        case .Recording:
            currentState = .Idle
            recordingLayer.removeFromSuperlayer()
            layer.addSublayer(idleLayer)
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
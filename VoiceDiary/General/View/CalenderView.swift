//
//  CalenderView.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/20.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

class CalenderView: UIView {
    enum Tags: Int {
        case RoundedView = 101
        case Label = 102
    }
    var progress = 0
    let size = DateTool.getDayCountOfMonth(NSDate())
    let offset = DateTool.getDayOfTheWeek(NSDate().startOfMonth()!) - 1
    var items:[UIView] = []
    var firstUpdated = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (!firstUpdated) {
            firstUpdated = true
            updateView()
            for v in items {
                let roundedView = v.viewWithTag(Tags.RoundedView.rawValue)!
                roundedView.setToRounded()
            }
        }
    }
}

// MARK: - Private
extension CalenderView {
    func setup() {
        self.backgroundColor = UIColor.clearColor()
        for i in 0..<size {
            let v = UIView()
            
            let roundedView = UIView()
            roundedView.backgroundColor = UIColor.yellowColor()
            roundedView.tag = Tags.RoundedView.rawValue
            roundedView.layer.masksToBounds = true
            v.addSubview(roundedView)
            
            let label = UILabel()
            label.tag = Tags.Label.rawValue
            label.text = "\(i+1)"
            label.textColor = UIColor(hex: 0x66696a)
            label.textAlignment = .Left
            v.addSubview(label)
            
            addSubview(v)
            items.append(v)
        }
    }
    
    func updateView() {
        let colNum = 7
        let rowNum = size / 7 + 1
        let itemWidth = self.bounds.width / CGFloat(colNum)
        let itemHeight = self.bounds.height / CGFloat(rowNum)
        
        for (i, v) in items.enumerate() {
            let x = CGFloat(i % colNum) * (itemWidth)
            let y = CGFloat(i / colNum) * (itemHeight)
            v.frame = CGRectMake(x, y, itemWidth, itemHeight)
            
            let margin = v.frame.width / 6
            let itemSize = itemWidth - margin * 2
            
            let roundedView = v.viewWithTag(Tags.RoundedView.rawValue)!
            roundedView.frame = CGRectMake(margin, margin, itemSize, itemSize)
            
            let label = v.viewWithTag(Tags.Label.rawValue)! as! UILabel
            label.alpha = CGFloat(progress)
            label.sizeToFit()
            let labelW = label.frame.size.width
            label.frame.origin.x = roundedView.frame.origin.x + (roundedView.frame.size.width - labelW) / 2
            label.frame.origin.y = roundedView.frame.maxY
        }
    }
    
    func updateLayer(duration: NSTimeInterval) {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration
        print(items[0].frame.size.width)
        for v in items {
            let roundedView = v.viewWithTag(Tags.RoundedView.rawValue)!
            animation.fromValue = NSNumber(double: Double(roundedView.layer.cornerRadius))
            animation.toValue = NSNumber(double: Double(roundedView.frame.size.width / 2))
            roundedView.layer.addAnimation(animation, forKey: "cornerRadius")
        }
    }

}

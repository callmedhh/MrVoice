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
    private var progress: Float = 0
    let size = DateTool.getDayCountOfMonth(NSDate())
    let offset = DateTool.getDayOfTheWeek(NSDate().startOfMonth()!) - 1
    var items:[UIView] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        update()
    }
}

// MARK: - Private
extension CalenderView {
    func setup() {
        self.backgroundColor = UIColor.clearColor()
        for i in 0..<size {
            let v = UIView()
            v.backgroundColor = UIColor(white: 1, alpha: CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            
            let roundedView = UIView()
            roundedView.backgroundColor = UIColor.yellowColor()
            roundedView.tag = Tags.RoundedView.rawValue
            v.addSubview(roundedView)
            
            let label = UILabel()
            label.tag = Tags.Label.rawValue
            label.text = "\(i+1)"
            label.textAlignment = .Left
            
            v.addSubview(label)
            addSubview(v)
            items.append(v)
        }
    }
    
    func update() {
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
//            roundedView.setToRounded()
            
            let label = v.viewWithTag(Tags.Label.rawValue)! as! UILabel
            label.backgroundColor = UIColor.redColor()
            label.textColor = UIColor.blackColor()
            label.sizeToFit()
            let labelW = label.frame.size.width
            label.frame.origin.x = roundedView.frame.origin.x + (roundedView.frame.size.width -Í labelW) / 2
            label.frame.origin.y = roundedView.frame.maxY
        }
    }

    
}

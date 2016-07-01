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
        for _ in 0..<offset{
            let v = UIView()
            
            let roundedView = UIView()
            roundedView.backgroundColor = UIColor.clearColor()
            roundedView.tag = Tags.RoundedView.rawValue
            v.addSubview(roundedView)
            
            let label = UILabel()
            label.tag = Tags.Label.rawValue
            v.addSubview(label)
            addSubview(v)
            items.append(v)
        }
        for i in 0..<size {
            let v = UIView()
            
            let roundedView = UIView()
            roundedView.backgroundColor = UIColor.yellowColor()
            roundedView.tag = Tags.RoundedView.rawValue
            v.addSubview(roundedView)
            
            let label = UILabel()
            label.tag = Tags.Label.rawValue
            label.text = "\(i+1)"
            label.textAlignment = .Center
            label.textColor = UIColor(hexString: "#4f5354")
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
            if progress == 0 {
                let margin:CGFloat = min(self.bounds.width,self.bounds.height) / 40
                let itemSize = min(itemWidth, itemHeight) - margin
                
                let roundedView = v.viewWithTag(Tags.RoundedView.rawValue)!
                roundedView.frame = CGRectMake(margin, margin, itemSize, itemSize)
                
                roundedView.setToRounded()
                
                let label = v.viewWithTag(Tags.Label.rawValue)!
                label.frame = CGRectMake(0, 0, 0, 0)
            }else {
                let margin:CGFloat = min(self.bounds.width,self.bounds.height) / 30
                let itemSize = min(itemWidth, itemHeight) - margin
                
                let roundedView = v.viewWithTag(Tags.RoundedView.rawValue)!
                roundedView.frame = CGRectMake(margin, 0, itemSize, itemSize)
                roundedView.setToRounded()
                
                let label = v.viewWithTag(Tags.Label.rawValue)!
                label.frame = CGRectMake(margin, itemSize, itemSize, margin*2)
            }
        }
        
    }
}

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
    let progress = 0
    let size = 31
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
        for _ in 0..<size {
            let v = UIView()
            v.backgroundColor = UIColor.grayColor()
            
            let roundedView = UIView()
            roundedView.backgroundColor = UIColor.yellowColor()
            roundedView.tag = Tags.RoundedView.rawValue
            v.addSubview(roundedView)
            
            let label = UILabel()
            label.tag = Tags.Label.rawValue
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
            
            let roundedView = v.viewWithTag(Tags.RoundedView.rawValue)!
            roundedView.frame = CGRectMake(5, 5, itemWidth-10, itemWidth-10)
            
        }
    }
}

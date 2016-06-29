//
//  CalenderView.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/20.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

class CalenderView: UIView {
    let progress = 0
    let size = 31
    var buttons:[UIView] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor(white: 1, alpha: 0.2)
        for _ in 0..<size {
            let v = UIView()
            v.backgroundColor = UIColor.yellowColor()
            addSubview(v)
            buttons.append(v)
        }
    }
    
    func update() {
        let colNum = 7
        let rowNum = size / 7 + 1
        let itemWidth = CGFloat(10)
        let itemHeight = CGFloat(10)
        let itemSpacingW = (self.bounds.width - itemWidth * CGFloat(colNum)) / (CGFloat(colNum) - 1)
        let itemSpacingH = (self.bounds.height - itemHeight * CGFloat(rowNum)) / (CGFloat(rowNum) - 1)
        
        for (i, button) in buttons.enumerate() {
            let x = CGFloat(i % colNum) * (itemWidth + itemSpacingW)
            let y = CGFloat(i / colNum) * (itemHeight + itemSpacingH)
            button.frame = CGRectMake(x, y, itemWidth, itemHeight)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        update()
    }
    
}

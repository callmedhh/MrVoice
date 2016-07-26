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
    var count = NSDate().getDayCountOfMonth()
    var offset = NSDate().startOfMonth()!.getDayOfTheWeek() - 1
    let colNum = 7
    var rowNum: Int {
        get { return (count + offset) / 7 + 1 }
    }
    
    var selectedDay: Int? = nil
    var itemButtons: [UIButton] = []
    var viewRecordTool: ViewRecordTool = ViewRecordTool()
    
    weak var playButton: UIButton?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
        updateRadius()
    }
}

// MARK: - Private
extension CalenderView {
    private func setup() {
        self.backgroundColor = DEBUG ? UIColor.redColor() : UIColor.clearColor()
        let date = NSDate()
        let recordModelList = viewRecordTool.getMonthDailyRecordList(month: date.getMonth(), year: date.getYear())
        for i in 0..<count {
            let button = UIButton()
            button.tag = i+1
            button.addTarget(self, action: #selector(buttonClicked), forControlEvents: .TouchUpInside)
            button.backgroundColor = DEBUG ? UIColor(white: 255, alpha: CGFloat(i % 8) / 8) : UIColor.clearColor()

            let roundedView = UIView()
            let recordModel = recordModelList[i]
            if recordModel.isRecorded {
                roundedView.backgroundColor = recordModel.recordModel?.mood.color()
            } else {
                roundedView.backgroundColor = UIColor.Calendar.nothing
            }
            roundedView.tag = Tags.RoundedView.rawValue
            roundedView.layer.masksToBounds = true
            button.addSubview(roundedView)
            
            let label = UILabel()
            label.tag = Tags.Label.rawValue
            label.text = "\(i+1)"
            label.textColor = UIColor.Calendar.nothing
            button.addSubview(label)

            addSubview(button)
            itemButtons.append(button)
        }
    }

    private func updateRadius() {
        for v in itemButtons {
            let roundedView = v.viewWithTag(Tags.RoundedView.rawValue)!
            roundedView.setToRounded()
        }
    }
}

// MARK: - Public
extension CalenderView {
    func updateView() {
        let width = self.bounds.width
        let height = self.bounds.height
        
        let itemWidth = width / CGFloat(colNum)
        let itemHeight = height / CGFloat(rowNum)
        
        for (i, button) in itemButtons.enumerate() {
            let index = i + offset
            let x = CGFloat(index % colNum) * (itemWidth)
            let y = CGFloat(index / colNum) * (itemHeight)
            button.frame = CGRectMake(x, y, itemWidth, itemHeight)
            
            let margin = button.frame.width / 5.5
            let itemSize = itemWidth - margin * 2
            
            let roundedView = button.viewWithTag(Tags.RoundedView.rawValue)!
            roundedView.frame = CGRectMake(margin, margin, itemSize, itemSize)
            
            let label = button.viewWithTag(Tags.Label.rawValue) as! UILabel
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
        animation.duration = duration + 0.05
        for v in itemButtons {
            let roundedView = v.viewWithTag(Tags.RoundedView.rawValue)!
            animation.fromValue = NSNumber(double: Double(roundedView.layer.cornerRadius))
            animation.toValue = NSNumber(double: Double(roundedView.frame.size.width / 2))
            roundedView.layer.addAnimation(animation, forKey: "cornerRadius")
        }
    }
    
    // TODO: REMOVE
    func updateRoundedViewColor(day: Int, mood: Mood){
        for (i, item) in itemButtons.enumerate() {
            if (i+1) == day {
                for subview in item.subviews {
                    if subview.tag == Tags.RoundedView.rawValue {
                        subview.backgroundColor = mood.color()
                        subview.setNeedsDisplay()
                    }
                }
            }
        }
    }
}


// MARK: - Override
extension CalenderView {
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        for item in itemButtons {
            if (CGRectContainsPoint(item.frame, point)) {
                return true
            }
        }
        return false
    }
}
// MARK: - Selector
extension CalenderView {
    func buttonClicked(sender: UIButton){
        let day = sender.tag
        selectedDay = day
        let date = NSDate()
        let month = date.getMonth()
        let year = date.getYear()
        let record = viewRecordTool.getRecordByTime(day, month: month, year: year)
        playButton?.hidden = !record.isRecorded
        playButton?.userInteractionEnabled = record.isRecorded
    }
}
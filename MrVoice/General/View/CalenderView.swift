//
//  CalenderView.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/20.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

class CalendarView: UIView {
    enum Tags: Int {
        case RoundedView = 101
        case Label = 102
    }
    enum Mode: Int {
        case Main
        case History
    }
    var mode = Mode.Main
    var count = NSDate().getDayCountOfMonth()
    var offset = NSDate().startOfMonth()!.getDayOfTheWeek() - 1
    let colNum = 7
    var rowNum: Int {
        return (count + offset) / 7 + 1
    }
    
    var selectedDay: Int? = nil
    var itemButtons: [UIButton] = []
    var playButton: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var firstLoad = false
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
        updateRadius()
    }
}

// MARK: - Private
extension CalendarView {
    private func setup() {
        self.backgroundColor = DEBUG ? UIColor.redColor() : UIColor.clearColor()
        let date = NSDate()
        let records = DB.Record.selectRecords(year: date.getYear(), month: date.getMonth())
        var recordDict =  [Int: Record]()
        for record in records {
            recordDict[record.date.day] = record
        }
        for i in 1...count {
            let button = UIButton()
            button.tag = i
            button.addTarget(self, action: #selector(buttonClicked), forControlEvents: .TouchUpInside)
            button.backgroundColor = DEBUG ? UIColor(white: 255, alpha: CGFloat(i % 8) / 8) : UIColor.clearColor()

            let roundedView = UIView()
            let record = recordDict[i]
            if let r = record {
                roundedView.backgroundColor = r.mood.color()
            } else {
                roundedView.backgroundColor = UIColor.Calendar.nothing
            }
            roundedView.userInteractionEnabled = false
            roundedView.tag = Tags.RoundedView.rawValue
            button.addSubview(roundedView)
            
            let label = UILabel()
            label.tag = Tags.Label.rawValue
            label.text = "\(i)"
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
    
    
    private func getItemWidth(width: CGFloat) -> CGFloat {
        return width / CGFloat(colNum)
    }
    
    private func getItemHeight(height: CGFloat) -> CGFloat {
        return height / CGFloat(rowNum)
    }
    
    private func getMargin(itemWidth: CGFloat) -> CGFloat {
        return itemWidth / 5.5
    }
    
    private func getRadius(itemWidth: CGFloat) -> CGFloat {
        return (itemWidth - getMargin(itemWidth) * 2) / 2
    }
}

// MARK: - Public
extension CalendarView {
    func updateView() {
        for (i, button) in itemButtons.enumerate() {
            let index = i + offset
            let itemW = getItemWidth(bounds.width)
            let itemH = getItemHeight(bounds.height)
            let x = CGFloat(index % colNum) * (itemW)
            let y = CGFloat(index / colNum) * (itemH)
            button.frame = CGRectMake(x, y, itemW, itemH)

            let roundedView = button.viewWithTag(Tags.RoundedView.rawValue)!
            let margin = getMargin(itemW)
            let radius = getRadius(itemW)
            roundedView.frame = CGRectMake(margin, margin, radius*2, radius*2)
            
            let label = button.viewWithTag(Tags.Label.rawValue) as! UILabel
            label.alpha = (mode == .History) ? 1 : 0
            label.sizeToFit()
            let labelW = label.frame.size.width
            label.frame.origin.x = roundedView.frame.origin.x + (roundedView.frame.size.width - labelW) / 2
            label.frame.origin.y = roundedView.frame.maxY
        }
    }
    
    func updateLayer(duration: NSTimeInterval, fromWidth: CGFloat, toWidth: CGFloat) {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration + 0.05
        for v in itemButtons {
            let roundedView = v.viewWithTag(Tags.RoundedView.rawValue)!
            animation.fromValue = NSNumber(double: Double(getRadius(getItemWidth(fromWidth))))
            animation.toValue = NSNumber(double: Double(getRadius(getItemWidth(toWidth))))
            roundedView.layer.addAnimation(animation, forKey: "cornerRadius")
        }
    }
    
    // TODO: REMOVE
    func updateRoundedViewColor(day: Int, mood: Mood){
        for (i, item) in itemButtons.enumerate() {
            if (i+1) == day {
                let subview = item.viewWithTag(Tags.RoundedView.rawValue)!
                subview.backgroundColor = mood.color()
                subview.setNeedsDisplay()
            }
        }
    }
}


// MARK: - Override
extension CalendarView {
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
extension CalendarView {
    func buttonClicked(sender: UIButton){
        selectedDay = sender.tag
        
        // play button
        let date = NSDate()
        let records = DB.Record.selectRecords(year: date.getYear(), month: date.getMonth(), day: selectedDay)
        playButton!.hidden = (records.count == 0)

        // update layer style
        for v in itemButtons {
            let roundedView = v.viewWithTag(Tags.RoundedView.rawValue)!
            roundedView.layer.shadowOpacity = 0
        }
        let roundedView = sender.viewWithTag(Tags.RoundedView.rawValue)!
        roundedView.layer.masksToBounds = false
        roundedView.layer.shadowColor = roundedView.backgroundColor!.CGColor
        roundedView.layer.shadowRadius = 5
        roundedView.layer.shadowOpacity = 0.8
        roundedView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
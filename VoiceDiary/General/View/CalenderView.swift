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
    var viewRecordTool: ViewRecordTool = ViewRecordTool()
    let recordTool: RecordTool = RecordTool()
    var playButton = UIButton()
    let date = NSDate()
    
    let happyMoodColor = UIColor(hexString: "#fda529")
    let noMoodColor = UIColor(hexString: "#fee140")
    let sadMoodColor = UIColor(hexString: "#a09f8e")
    let notRecordedColor = UIColor(hexString: "#3e4243")
    
    var filename: String? = nil
    
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
        
        let month = date.getMonth()
        let year = date.getYear()
        
        let recordModelList = viewRecordTool.getMonthDailyRecordList(month: month, year: year)
        for i in 0..<size {
            let v = UIView()
            
            let roundedView = UIView()
            let recordModel = recordModelList[i]
            if recordModel.isRecorded {
                switch recordModel.recordModel!.mood {
                case Mood.Happy.rawValue:
                    roundedView.backgroundColor = happyMoodColor
                case Mood.NoMood.rawValue:
                    roundedView.backgroundColor = noMoodColor
                case Mood.Sad.rawValue:
                    roundedView.backgroundColor = sadMoodColor
                default:
                    roundedView.backgroundColor = notRecordedColor
                }
                log.debug(i)
            } else {
                roundedView.backgroundColor = notRecordedColor
            }
            roundedView.tag = Tags.RoundedView.rawValue
            roundedView.layer.masksToBounds = true
            v.addSubview(roundedView)
            
            let label = UILabel()
            label.tag = Tags.Label.rawValue
            label.text = "\(i+1)"
            label.textColor = UIColor(hex: 0x66696a)
            label.textAlignment = .Left
            v.addSubview(label)
            
            let button = UIButton()
            button.tag = i+1
            button.addTarget(self, action: #selector(buttonClicked), forControlEvents: .TouchUpInside)
            v.addSubview(button)
            
            addSubview(v)
            items.append(v)
        }
        addSubview(playButton)
    }
    
    func updateView() {
        let colNum = 7
        let rowNum = (size + offset) / 7 + 1
        let width = self.bounds.width
        let height = self.bounds.height
        
        let itemWidth = width / CGFloat(colNum)
        let itemHeight = height * 0.8 / CGFloat(rowNum)
        
        for (i, v) in items.enumerate() {
            let index = i + offset
            let x = CGFloat(index % colNum) * (itemWidth)
            let y = CGFloat(index / colNum) * (itemHeight)
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
            
            let button = v.viewWithTag(i+1) as! UIButton
            button.frame = CGRectMake(margin, margin, itemSize, itemSize)
            button.backgroundColor = UIColor.clearColor()
        }
        
        playButton.frame = CGRectMake(width/2-height*0.075, height*0.8, height*0.15, height*0.15)
        playButton.backgroundColor = UIColor(hexString: "#fee140")
        playButton.hidden = true
        playButton.setToRounded()
    }
    
    func buttonClicked(sender: UIButton){
        let day = sender.tag
        let month = date.getMonth()
        let year = date.getYear()
        let record = viewRecordTool.getRecordByTime(day, month: month, year: year)
        if record.isRecorded {
            playButton.tag = day
            playButton.hidden = false
            playButton.addTarget(self, action: #selector(recordPlayBtnClicked), forControlEvents: .TouchUpInside)
            filename = record.recordModel!.filename
        } else {
            playButton.hidden = true
        }
    }
    
    func recordPlayBtnClicked(sender: UIButton){
        recordTool.startPlaying(filename!)
    }
    
    func updateLayer(duration: NSTimeInterval) {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration
        for v in items {
            let roundedView = v.viewWithTag(Tags.RoundedView.rawValue)!
            animation.fromValue = NSNumber(double: Double(roundedView.layer.cornerRadius))
            animation.toValue = NSNumber(double: Double(roundedView.frame.size.width / 2))
            roundedView.layer.addAnimation(animation, forKey: "cornerRadius")
        }
    }
    
}


// MARK: - Override
extension CalenderView {
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if (!playButton.hidden) {
            if (CGRectContainsPoint(playButton.frame, point)) {
                return true
            }
        }
        
        for item in items {
            if (CGRectContainsPoint(item.frame, point)) {
                return true
            }
        }
        
        return false
    }
}
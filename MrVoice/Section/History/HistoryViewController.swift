//
//  HistoryViewController.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/22.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var monthNumberLabel: UILabel!
    @IBOutlet weak var monthTextLabel: UILabel!
    @IBOutlet weak var playButton: RecordButton!
    
    var recordTool: RecordTool = RecordTool()

    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        let date = NSDate()
        monthNumberLabel.text =  date.getMonthStr()
        monthTextLabel.text = date.getMonthDes()
        calendarView.mode = .History
    }
    @IBAction func backgroundTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLayoutSubviews() {
        playButton.layoutIfNeeded()
    }
    
//    @IBAction func playPressed(sender: AnyObject) {
//        let date = NSDate()
//        let month = date.getMonth()
//        let year = date.getYear()
//        let record = viewRecordTool.getRecordByTime(calendarView.selectedDay!, month: month, year: year)
//        if record.isRecorded {
//            let filename = record.recordModel!.filename
//            recordTool.startPlaying(filename)
//        } else {
//            
//        }
//    }
}

// MARK: - WithCalendarViewController
extension HistoryViewController: WithCalendarViewController {
    func getCalendarView() -> CalendarView {
        return calendarView
    }
}
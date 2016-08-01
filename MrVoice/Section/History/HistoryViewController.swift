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
        calendarView.playButton = playButton
        playButton.delegate = self
        playButton.hidden = true
        playButton.currentState = .Paused
    }
    @IBAction func backgroundTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLayoutSubviews() {
        playButton.layoutIfNeeded()
    }
}

// MARK: - WithCalendarViewController
extension HistoryViewController: WithCalendarViewController {
    func getCalendarView() -> CalendarView {
        return calendarView
    }
}

// MARK: - RecordButton
extension HistoryViewController: RecordButtonHandler {
    func stateChanged(state: RecordButton.State) {
        switch state {
        case .Paused:
            recordTool.stopPlaying()
        case .Playing:
            let date = NSDate()
            let record = DB.Record.selectRecords(year: date.getYear(), month: date.getMonth(), day: calendarView.selectedDay!)
            let filename = record[0].filename
            recordTool.startPlaying(filename) { err in
                if let error = err {
                    log.error(error)
                }
                self.playButton.currentState = .Paused
            }
        default:
            break
        }
    }
}
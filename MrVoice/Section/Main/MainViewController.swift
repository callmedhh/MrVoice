//
//  ViewController.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/8.
//  Copyright © 2016年 dongyixuan. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore
import Async

// BUG: 如果已经到了第二天 必须要杀了应用才能录音
class MainViewController: UIViewController, UINavigationControllerDelegate{
    let recordTool: RecordTool = RecordTool()
    var recordingSession: AVAudioSession!
    var mood = Mood.Flat
    var startDate: NSDate? = nil
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var emojiView: UIView!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet var moodButtons: [UIButton]!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var calendarAspect: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        navigationController?.delegate = self
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { result in
                if (result) {
                    log.verbose("Record Permission ALLOWED")
                } else {
                    log.verbose("Record Permission NOT ALLOWED")
                }
            }
        } catch {
            log.error("Catch recordingSession error")
        }
        monthLabel.text = today.getMonthStr()
        dayLabel.text = today.getDayStr()
        emojiView.hidden = true
        progressView.hidden = true
        recordButton.delegate = self
        recordButton.currentState = .Paused

        calendarAspect.setMultiplier(CGFloat(calendarView.colNum) / CGFloat(calendarView.rowNum))
        addShadow(finishButton, color: UIColor.General.mainColor)
        checkRecordButton()
    }
// TODO: REFACTOR
    @IBAction func happyMood(button: UIButton) {
        mood = Mood.Happy
        clearMoodButtonsShadow()
        addShadow(button, color: UIColor.Calendar.happy)
    }
    
    @IBAction func flatMood(button: UIButton) {
        mood = Mood.Flat
        clearMoodButtonsShadow()
        addShadow(button, color: UIColor.Calendar.flat)
    }
    
    @IBAction func badMood(button: UIButton) {
        mood = Mood.Sad
        clearMoodButtonsShadow()
        addShadow(button, color: UIColor.Calendar.sad)
    }
    
    @IBAction func finishRecordButtonPressed(sender: UIButton) {
        clearMoodButtonsShadow()
        recordTool.saveRecordingWithMood(mood)
        recordView.hidden = false
        emojiView.hidden = true
        recordButton.currentState = .Disabled
        
        let date = NSDate()
        let day = date.getDay()
        calendarView.updateRoundedViewColor(day, mood: mood)
    }

    let animatedTransition = HistoryTransitionController()
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedTransition
    }
}

// MARK: - Private
extension MainViewController {
    private func checkRecordButton() {
        let date = NSDate()
        let records = DB.Record.selectRecords(year: date.getYear(), month: date.getMonth(), day: date.getDay())
        if records.count > 0 {
            recordButton.currentState = .Disabled
        }
    }
    private func clearMoodButtonsShadow() {
        for view in moodButtons {
            view.layer.shadowOpacity = 0
        }
    }
    
    private func addShadow(button: UIView, color: UIColor) {
        button.layer.shadowColor = color.CGColor
        button.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 1
    }
}

// MARK: - WithCalendarViewController
extension MainViewController: WithCalendarViewController {
    func getCalendarView() -> CalendarView {
        return calendarView
    }
}

// MARK: - RecordButtonDelegate
extension MainViewController: RecordButtonHandler {
    func stateChanged(state: RecordButton.State) {
        if(state == .Recording) {
            startDate = NSDate()
            mood = .Flat
            progressView.hidden = false
            recordTool.startRecording()
            
            func updateProgressView(sDate: NSDate) {
                let ms = CGFloat(NSDate().timeIntervalSince1970 - sDate.timeIntervalSince1970)
                progressView.progress = ms / 60
                if let date = self.startDate {
                    Async.main(after: 0.3, block: { 
                        updateProgressView(date)  
                    })
                }
            }
            updateProgressView(startDate!)
        }
        if(state == .Idle) {
            recordButton.currentState = .Disabled
            flatMood(moodButtons[1])
            startDate = nil
            recordTool.finishRecording(success: true)
            recordView.hidden = true
            emojiView.hidden = false
            progressView.hidden = true
        }
    }
}
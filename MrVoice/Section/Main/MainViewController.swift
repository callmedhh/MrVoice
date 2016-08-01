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

class MainViewController: UIViewController, UINavigationControllerDelegate{
    let recordTool: RecordTool = RecordTool()
    var recordingSession: AVAudioSession!
    var mood: Mood? = nil
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

        calendarAspect.setMultiplier(CGFloat(calendarView.colNum) / CGFloat(calendarView.rowNum))
        addShadow(finishButton, opacity: 1.0)
        checkRecordButton()
    }

    @IBAction func happyMood(sender: UIButton) {
        mood = Mood.Happy
        finishButton.enabled = true
        setButtonSelected(sender, selected: true)
    }
    
    @IBAction func flatMood(sender: UIButton) {
        mood = Mood.Flat
        finishButton.enabled = true
        setButtonSelected(sender, selected: true)
    }
    
    @IBAction func badMood(sender: UIButton) {
        mood = Mood.Sad
        finishButton.enabled = true
        setButtonSelected(sender, selected: true)
    }
    
    @IBAction func finishRecordButtonPressed(sender: UIButton) {
        clearMoodButtonsShadow()
        guard let mood = mood else {
            log.error("异常")
            return
        }
        recordTool.saveRecordingWithMood(mood)
        recordView.hidden = false
        emojiView.hidden = true
        
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
        for subview in moodButtons {
            subview.layer.shadowOpacity = 0
        }
    }
    
    private func setButtonSelected(button: UIButton, selected: Bool) {
        clearMoodButtonsShadow()
        addShadow(button, opacity: selected ? 1 : 0)
    }
    
    private func addShadow(button: UIView, opacity: Float) {
        button.layer.shadowColor = UIColor.General.mainColor.CGColor
        button.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = opacity
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
            mood = nil
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
            startDate = nil
            recordTool.finishRecording(success: true)
            recordView.hidden = true
            emojiView.hidden = false
            progressView.hidden = true
        }
    }
}
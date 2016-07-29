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

class MainViewController: UIViewController, UINavigationControllerDelegate{
    let recordTool: RecordTool = RecordTool()
    var recordingSession: AVAudioSession!
    var mood: Mood? = nil
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var emojiView: UIView!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var completeBtn: UIButton!
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
        
        calendarAspect.setMultiplier(CGFloat(calendarView.colNum) / CGFloat(calendarView.rowNum))
    }
    
    override func viewDidAppear(animated: Bool) {
        progressView.progress = 0.5
    }
    
//    @IBAction func recordTapped(sender: AnyObject) {
//        if(recordTool.audioRecorder == nil){
//            recordTool.startRecording()
//            recordBtn.currentState = .Recording
//            mood = nil
//        }else{
//            recordTool.finishRecording(success: true)
//            recordView.hidden = true
//            emojiView.hidden = false
//        }
//        recordBtn.setNeedsDisplay()
//    }
    
    @IBAction func happyMood(sender: AnyObject) {
        mood = Mood.Happy
        completeBtn.enabled = true
    }
    
    @IBAction func noMood(sender: AnyObject) {
        mood = Mood.Flat
        completeBtn.enabled = true
    }
    
    @IBAction func badMood(sender: AnyObject) {
        mood = Mood.Sad
        completeBtn.enabled = true
    }
    
    @IBAction func finishRecordBtnPressed(sender: AnyObject) {
//        if let mood = mood {
//            recordTool.saveRecordingWithMood(mood)
//            recordView.hidden = false
//            emojiView.hidden = true
//            
//            recordBtn.setNeedsDisplay()
//            
//            // TODO: RELOAD DATA
//            for viewItem in self.view.subviews {
//                if viewItem is CalendarView {
//                    let date = NSDate()
//                    let day = date.getDay()
//                    let calendarView = viewItem as! CalendarView
//                    calendarView.updateRoundedViewColor(day, mood: mood)
//                }
//            }
//        } else {
//            let button = sender as! UIButton
//            button.enabled = false
//            return
//        }
    }
    
    
    let animatedTransition = HistoryTransitionController()
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedTransition
    }
}


// MARK: - WithCalendarViewController
extension MainViewController: WithCalendarViewController {
    func getCalendarView() -> CalendarView {
        return calendarView
    }
}
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

class MainViewController: UIViewController {
    let recordTool: RecordTool = RecordTool()
    var recordingSession: AVAudioSession!
    let dbTool = Database()
    
    @IBOutlet weak var borderView: BorderView!
    @IBOutlet weak var recordBtn: RecordButton!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var emojiView: UIView!
    @IBOutlet weak var mainpageGreetingView: UIView!
    @IBOutlet weak var emojiGreetingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view, typically from a nib.
        dbTool.createTable()
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
        let month = DateTool.getMonth()
        let day = DateTool.getDay()
        monthLabel.text = month
        dayLabel.text = day
        recordBtn.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBarHidden = true
        emojiView.hidden = true
        emojiGreetingView.hidden = true
        
    }

    @IBAction func recordTapped(sender: AnyObject) {
        if(recordTool.audioRecorder == nil){
            recordTool.startRecording()
            recordBtn.currentState = .Recording
            borderView.animate()
        }else{
//            recordTool.finishRecording(success: true)
//            recordBtn.currentState = .Idle
            borderView.cancelAnimate()
            recordView.hidden = true
            emojiView.hidden = false
            mainpageGreetingView.hidden = true
            emojiGreetingView.hidden = false
        }
        recordBtn.setNeedsDisplay()
    }
    
    @IBAction func happyMood(sender: AnyObject) {
    }
    
    @IBAction func noMood(sender: AnyObject) {
        
    }
    
    @IBAction func badMood(sender: AnyObject) {
    }
    
    @IBAction func finishRecordBtnPressed(sender: AnyObject) {
    }
    
}


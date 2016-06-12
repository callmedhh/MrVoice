//
//  ViewController.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/8.
//  Copyright © 2016年 dongyixuan. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    let recordTool: RecordTool = RecordTool()
    let folderPath = FilePathTool.getDocumentsDirectory()
    var recordingSession: AVAudioSession!
    let dbTool = Database()
    
    @IBOutlet weak var recordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dbTool.createTable()
        recordingSession = AVAudioSession.sharedInstance()
        do{
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { _ in
            }
        }catch{
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordTapped(sender: AnyObject) {
        let nowDate = NSDate()
        let dateString = dateToString(nowDate)
        let filePath = folderPath.stringByAppendingPathComponent("\(dateString).m4a")
        if(recordTool.audioRecorder == nil){
            recordTool.startRecording(filePath)
            recordBtn.setTitle("点击停止录音", forState: .Normal)
        }else{
            recordTool.finishRecording(success: true)
            recordBtn.setTitle("点击开始录音", forState: .Normal)
        }
    }
    
    func dateToString(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }

}


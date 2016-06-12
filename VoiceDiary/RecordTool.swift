//
//  RecordTool.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/9.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation
import AVFoundation
class RecordTool: NSObject, AVAudioRecorderDelegate{
   
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var dbTool: Database = Database()
    var filePath: String? = nil
   
    
    func startRecording(filePath:String){
        self.filePath = filePath
        let fileURL = NSURL(fileURLWithPath: filePath)
        //audio settings
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        do{
            print(fileURL)
            audioRecorder = try AVAudioRecorder(URL: fileURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        }catch{
            finishRecording(success: false)
        }
    }
    
    
    func finishRecording(success success: Bool){
        if audioRecorder == nil {
            print("error")
        } else if let filePath = self.filePath {
            dbTool.addRecord(fileUrl: filePath)
            audioRecorder.stop()
            audioRecorder = nil
        }
        self.filePath = nil
    }
    
    func startPlaying(recordurl: String){
        let url = NSURL(fileURLWithPath: recordurl)
        do{
            print(url)
            let sound = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer = sound
            sound.play()
        }catch{
            
        }
    }
    
    func stopPlaying(){
        if audioPlayer != nil{
            audioPlayer.stop()
            audioPlayer = nil
        }
    }
    
}

extension String {
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
}
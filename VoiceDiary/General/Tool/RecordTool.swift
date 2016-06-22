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
    var mood: Int? = nil
}

// MARK: - Private
extension RecordTool {
    private func buildFilePath() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
        let dateString = dateFormatter.stringFromDate(NSDate())
        let folderPath = FilePathTool.getDocumentsDirectory()
        return folderPath.stringByAppendingPathComponent("\(dateString).m4a")
    }
}

// MARK: - Record
extension RecordTool {
    func startRecording(){
        let path = buildFilePath()
        self.filePath = path
        let fileURL = NSURL(fileURLWithPath: path)
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
        } else {
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
    
    func saveRecordingWithMood(mood mood: Int) {
        if let filePath = self.filePath {
            dbTool.addRecord(fileUrl: filePath, moodValue: mood)
        }
        self.filePath = nil
    }
    
    
}

// MARK: - Play
extension RecordTool {
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
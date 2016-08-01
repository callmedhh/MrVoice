
//  RecordTool.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/9.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import Foundation
import AVFoundation

typealias PlayCompletion = (NSError?) -> Void

let recordTool = RecordTool()

class RecordTool: NSObject {
    var audioRecorder: AVAudioRecorder? = nil
    var audioPlayer: AVAudioPlayer? = nil
    var filePath: String? = nil
    var completion: PlayCompletion? = nil
}

// MARK: - Private
extension RecordTool {
    private func buildFilePath(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
        let dateString = dateFormatter.stringFromDate(date)
        let folderPath = FilePath.documentDirectory()
        return folderPath.stringByAppendingPathComponent("\(dateString).m4a")
    }
}

// MARK: - Record
extension RecordTool {
    func startRecording(){
        let path = buildFilePath(NSDate())
        self.filePath = path
        let fileURL = NSURL(fileURLWithPath: path)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        do {
            let ar = try AVAudioRecorder(URL: fileURL, settings: settings)
            // TODO: handle record event
            ar.record()
            audioRecorder = ar
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success success: Bool) {
        guard let ar = audioRecorder else {
            log.error("no audio recorder")
            return
        }
        ar.stop()
        audioRecorder = nil
    }
}

// MARK: - Play
extension RecordTool {
    func startPlaying(filename: String, completion handler: (NSError?) -> Void){
        completion = handler
        let folderPath = FilePath.documentDirectory()
        let filepath = folderPath.stringByAppendingPathComponent(filename)
        let url = NSURL(fileURLWithPath: filepath)
        log.debug(url)
        do{
            let sound = try AVAudioPlayer(contentsOfURL: url)
            sound.delegate = self
            audioPlayer = sound
            sound.play()
        } catch {
            log.error(error)
        }
    }
    func stopPlaying(){
        if let ar = audioPlayer {
            ar.stop()
        }
        completion = nil
        audioPlayer = nil
    }
}

// MARK: - AVAudioPlayerDelegate
extension RecordTool: AVAudioPlayerDelegate {
    // TODO: USE AUDIO SESSION
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        completion?(nil)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        completion?(error)
    }
}
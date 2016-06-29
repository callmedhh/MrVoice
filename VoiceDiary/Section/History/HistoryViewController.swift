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
    @IBOutlet weak var playBtn: UIButton!
    var recordTool: RecordTool = RecordTool()

    @IBOutlet weak var calenderView: CalenderView!
    var recordUrl: String?
    override func viewDidLoad() {
        monthNumberLabel.text =  DateTool.getMonth()
        monthTextLabel.text = DateTool.getMonthDes()
        playBtn.hidden = true
    }
    
    @IBAction func playBtnPressed(sender: AnyObject) {
        playBtn.setTitle("点击暂停", forState: .Normal)
        if let recordPath = recordUrl {
            recordTool.startPlaying(recordPath)
        }
    }
    
    @IBAction func backgroundBtnPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

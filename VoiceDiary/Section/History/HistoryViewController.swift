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
    var recordTool: RecordTool = RecordTool()

    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var calenderView: CalenderView!
    var recordUrl: String?
    override func viewDidLoad() {
        monthNumberLabel.text =  DateTool.getMonth()
        monthTextLabel.text = DateTool.getMonthDes()
        backgroundBtn.backgroundColor = UIColor.clearColor()
     
    }
    @IBAction func backgroundTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

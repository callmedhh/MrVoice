//
//  RecordListTableViewController.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/9.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

class RecordListTableViewController: UITableViewController {
    private let cellIdentifier = "recordCell"
    private var recordList: [RecordModel] = []
    private let dbTool  = Database()
    private let recordTool = RecordTool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbTool.createTable()
        recordList = dbTool.selectALLRecordList()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recordList.count
    }

    
    @IBAction func playRecordBtn(sender: AnyObject) {
        let button = sender as! UIButton
        let cell = button.superview?.superview as! UITableViewCell
        let tableView = cell.superview?.superview as! UITableView
        let indexPath = tableView.indexPathForCell(cell)
        recordTool.startPlaying(recordList[(indexPath?.row)!].recordUrl)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let textLabel = cell.viewWithTag(11) as! UILabel
        textLabel.text = recordList[indexPath.row].recordUrl

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

}

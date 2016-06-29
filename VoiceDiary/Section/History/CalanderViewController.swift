//
//  CalanderViewController.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/20.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

let identifier = "calendarIdentifier"


class CalanderViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    var state: Float = 0
    var recordModelList: [DailyRecord] = []
    var viewRecordTool: ViewRecordTool = ViewRecordTool()
    var weekdayOfMonthStart = 0
    var dbTool: Database = Database()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        let date = NSDate()
        let month = date.getMonth()
        let year = date.getYear()
        weekdayOfMonthStart = DateTool.getDayOfTheWeek(date.startOfMonth()!)
        recordModelList = viewRecordTool.getAllDailyRecordList(month, year: year)
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CalenderViewCell
        if state == 0 {
            if indexPath.row < weekdayOfMonthStart-1 {
                cell.circleView.circleColor = UIColor.clearColor()
            }else if recordModelList[indexPath.row].isRecorded{
                cell.circleView.circleColor = UIColor.yellowColor()
            }else{
                cell.circleView.circleColor = UIColor(hexString: "#3f4244")!
            }
        }else if state == 1 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CalenderViewCell
            if indexPath.row < weekdayOfMonthStart-1 {
                cell.circleView.circleColor = UIColor.clearColor()
            }else {
                if recordModelList[indexPath.row].isRecorded{
                    cell.circleView.circleColor = UIColor.yellowColor()
                }else{
                    cell.circleView.circleColor = UIColor(hexString: "#3f4244")!
                }
                cell.numberLabel.text = "\(indexPath.row - weekdayOfMonthStart + 2)"
            }
            
            cell.circleView.setNeedsDisplay()
        }
        cell.circleView.setNeedsDisplay()
        return cell
    }
    func reloadRecordModelList(){
        let date = NSDate()
        let month = date.getMonth()
        let year = date.getYear()
        recordModelList = viewRecordTool.getAllDailyRecordList(month, year: year)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordModelList.count
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        var cellWidth: CGFloat = 0
        var cellHeight: CGFloat = 0
        
        if state == 0 {
            cellWidth = width / 15.0
            cellHeight = cellWidth
        }else if state == 1 {
            let width = collectionView.frame.size.width
            cellWidth = width / 12.0
            cellHeight = cellWidth * 2
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        var top: CGFloat = 0
        var left: CGFloat = 0
        var bottom: CGFloat = 0
        var right: CGFloat = 0
        if state == 0 {
            top = height / 10.0
            left = width / 8.0
            bottom = height / 10.0
            right = width / 8.0
        }else if state == 1 {
            top = height / 10.0
            left = width / 15.0
            bottom = height / 10.0
            right = width / 15.0
        }
        let insetSection = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return insetSection
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        let height = collectionView.frame.size.height
        var space: CGFloat = 0
        if state == 0 {
            space = height / 15.0
        }else if state ==  1 {
            space = height / 25.0
        }
        return space
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        let width = collectionView.frame.size.width
        return width/30
    }
    
    @IBAction func showHistoryBtnPressed(sender: AnyObject) {
        self.parentViewController?.performSegueWithIdentifier("showHistory", sender: sender)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if state == 0 {
            return
        }else if state == 1 {
            let recordModel = recordModelList[indexPath.row]
            if recordModel.isRecorded {
                let date = recordModel.date
                let record = dbTool.selectRecordListByDate(date)
                let recordUrl = record.recordUrl
                let detailCalendarVC = self.parentViewController as! HistoryViewController
                detailCalendarVC.playBtn.hidden = false
                detailCalendarVC.recordUrl = recordUrl
            }
        }
    }
    
}

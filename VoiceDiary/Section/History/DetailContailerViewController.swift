//
//  DetailContailerViewController.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/23.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit



class DetailContailerViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    let identifier = "calendarIdentifier"
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
        let cellWidth = width / 12.0
        let cellHeight = cellWidth * 2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        let insetSection = UIEdgeInsets(top: height/10.0, left: width/15.0, bottom: 10.0, right: width/15.0)
        return insetSection
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        let height = collectionView.frame.size.height
        return height/25
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        let width = collectionView.frame.size.width
        return width/30
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
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
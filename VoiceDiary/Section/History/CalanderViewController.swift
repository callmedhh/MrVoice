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
    var recordModelList: [DailyRecord] = []
    var viewRecordTool: ViewRecordTool = ViewRecordTool()
    var weekdayOfMonthStart = 0
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
        }else if recordModelList[indexPath.row].isRecorded{
            cell.circleView.circleColor = UIColor.yellowColor()
        }else{
            cell.circleView.circleColor = UIColor.grayColor()
        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordModelList.count
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let cellWidth = width / 10.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let width = collectionView.frame.size.width
        let insetSection = UIEdgeInsets(top: 10.0, left: width/30.0, bottom: 10.0, right: width/30.0)
        return insetSection
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        let width = collectionView.frame.size.width
        return width/30
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        let width = collectionView.frame.size.width
        return width/30
    }
}

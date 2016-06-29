//
//  CalenderViewCell.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/21.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

class CalenderViewCell: UICollectionViewCell {
    @IBOutlet weak var circleView: CircleView!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    let happyColor = UIColor(hexString: "#fda529")
    let nomoodColor = UIColor(hexString: "#fee140")
    let sadColor = UIColor(hexString: "#a09f8e")
    
}

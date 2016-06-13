//
//  UIButtonExtension.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/13.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

extension UIButton {
    func setToRounded() {
        layer.cornerRadius = min(frame.size.width, frame.size.height) / 2;
        layer.masksToBounds = true;
    }
}
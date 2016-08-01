//
//  UIColorExtension.swift
//  VoiceDiary
//
//  Created by why on 7/26/16.
//  Copyright © 2016 Lemur. All rights reserved.
//

import UIKit

extension UIColor {
    struct General {
        static let mainColor = UIColor(hexString: "#FFE327")!
    }
    struct Calendar {
        static let nothing = UIColor(hexString: "#D8D8D8", alpha: 0.2)!
        static let happy = UIColor(hexString: "#FFB714", alpha: 1.0)!
        static let flat = UIColor(hexString: "#F8E71C", alpha: 1.0)!
        static let sad = UIColor(hexString: "#E0CB7E", alpha: 1.0)!
    }
    struct ProgressView {
        static let backgroundColor = UIColor(white: 1, alpha: 0.2)
    }
    struct RecordButton {
        static let strokeColor = UIColor(hexString: "#7F5A05")!
    }
}
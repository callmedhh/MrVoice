//
//  UIConstraintExtension.swift
//  MrVoice
//
//  Created by why on 7/26/16.
//  Copyright © 2016 Lemur. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivateConstraints([self])

        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
        newConstraint.active = true
        
        NSLayoutConstraint.activateConstraints([newConstraint])
        return newConstraint
    }
}

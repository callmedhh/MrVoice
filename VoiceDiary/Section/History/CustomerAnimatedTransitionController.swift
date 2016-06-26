//
//  CustomerAnimatedTransitionController.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/26.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

class CustomerAnimatedTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.5
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        let containerView = transitionContext.containerView()
        
        toViewController.view.frame = finalFrame
        containerView?.addSubview(toViewController.view)
        containerView?.sendSubviewToBack(toViewController.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            fromViewController.view.alpha = 0
            toViewController.view.alpha = 1.0
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
        })
    }
}

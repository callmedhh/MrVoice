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
        return 2
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()
        toViewController.view.frame = finalFrame
        containerView?.addSubview(toViewController.view)
        containerView?.sendSubviewToBack(toViewController.view)
        
        if fromViewController is MainViewController && toViewController is HistoryViewController{
            let mainVC = fromViewController as! MainViewController
            let detailContainerVC = toViewController as! HistoryViewController
            let calenderViewFrame = mainVC.calenderView.frame
            //隐藏calendarView
            mainVC.calenderView.hidden = true
            detailContainerVC.calenderContainerView.hidden = true
            
            let snapshotView = mainVC.calenderView.snapshotViewAfterScreenUpdates(false)
            snapshotView.frame = calenderViewFrame
            containerView?.addSubview(snapshotView)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                detailContainerVC.calenderContainerView.setNeedsLayout()
                detailContainerVC.calenderContainerView.layoutIfNeeded()
                let calendarViewFrame = detailContainerVC.calenderContainerView.frame
                snapshotView.frame = calendarViewFrame
                snapshotView.alpha = 0
                fromViewController.view.alpha = 0
            }, completion: { finished in
                snapshotView.removeFromSuperview()
                fromViewController.view.alpha = 1.0
                transitionContext.completeTransition(true)
                detailContainerVC.calenderContainerView.hidden = false
                mainVC.calenderView.hidden = false
            })
        } else {
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                fromViewController.view.alpha = 0
                }, completion: { finished in
                    fromViewController.view.alpha = 1.0
                    transitionContext.completeTransition(true)
            })
        }
        
        

        
    }
}

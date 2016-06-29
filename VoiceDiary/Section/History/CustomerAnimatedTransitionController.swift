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
        return 1.4
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()!
        toViewController.view.frame = finalFrame
        containerView.insertSubview(toViewController.view, atIndex: 0)
        
        if fromViewController is MainViewController && toViewController is HistoryViewController{
            let fromVC = fromViewController as! MainViewController
            let toVC = toViewController as! HistoryViewController

            toVC.calenderView.setNeedsLayout()
            toVC.calenderView.layoutIfNeeded()
            toVC.calenderView.hidden = true
            
            let originFromVCBackgroundColor = fromVC.view.backgroundColor
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                fromVC.calenderView.frame = toVC.calenderView.frame
                fromVC.calenderView.update()
                for v in fromViewController.view.subviews {
                    if v is CalenderView {
                        continue
                    } else {
                        v.alpha = 0
                    }
                }
                fromViewController.view.backgroundColor = UIColor.clearColor()
            }, completion: { finished in
                for v in fromViewController.view.subviews {
                    if v is CalenderView {
                        continue
                    } else {
                        v.alpha = 1
                    }
                }
                fromViewController.view.backgroundColor = originFromVCBackgroundColor
                
                toVC.calenderView.hidden = false
                transitionContext.completeTransition(true)
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

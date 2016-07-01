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
        return 1.2
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

            let originFrame = fromVC.calenderView.frame
            let originFromVCBackgroundColor = fromVC.view.backgroundColor
            
            toVC.calenderView.progress = 1
            toVC.calenderView.setNeedsLayout()
            toVC.calenderView.layoutIfNeeded()
            toVC.calenderView.hidden = true
            
            
            let duration = transitionDuration(transitionContext)
            UIView.animateWithDuration(duration, animations: {
                fromVC.calenderView.frame = toVC.calenderView.frame
                fromVC.calenderView.progress = 1
                fromVC.calenderView.updateView()
                fromVC.calenderView.updateLayer(duration)
                for v in fromViewController.view.subviews {
                    if v is CalenderView {
                        continue
                    } else {
                        v.alpha = 0
                    }
                }
                fromViewController.view.backgroundColor = UIColor.clearColor()
            }, completion: { finished in
                fromVC.calenderView.frame = originFrame
                fromVC.calenderView.progress = 0
                fromVC.calenderView.updateView()
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

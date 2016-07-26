//
//  CustomerAnimatedTransitionController.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/26.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

class HistoryTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
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
        
        if let fromVC = fromViewController as? MainViewController, let toVC = toViewController as? HistoryViewController {
            toVC.calendarView.setNeedsLayout()
            toVC.calendarView.layoutIfNeeded()
            toVC.calendarView.hidden = true
            fromVC.calendarView.hidden = true
            toVC.view.alpha = 0
            
            let originFrame =  fromVC.view.convertRect(fromVC.calendarView.frame, toView: containerView)
            let calendarView = CalendarView(frame: originFrame)
            containerView.addSubview(calendarView)
            
            let duration = transitionDuration(transitionContext)
            
            // vc.view
            UIView.animateWithDuration(duration/2, animations: {
                fromVC.view.alpha = 0
            }, completion: { finished in
                UIView.animateWithDuration(duration/2, animations: {
                    toVC.view.alpha = 1
                }, completion: { finished in
                    fromVC.view.alpha = 1
                    transitionContext.completeTransition(true)
                })
            })
            
            // calendarView
            calendarView.frame = originFrame
            calendarView.updateView()
            UIView.animateWithDuration(duration, animations: {
                calendarView.frame = toVC.calendarView.frame
                calendarView.updateView()
                calendarView.updateLayer(duration, fromWidth: originFrame.size.width, toWidth: toVC.calendarView.frame.size.width)
            }, completion: { finished in
                calendarView.removeFromSuperview()
                toVC.calendarView.hidden = false
                fromVC.calendarView.hidden = false
            })
        } else if fromViewController is HistoryViewController && toViewController is MainViewController {
            transitionContext.completeTransition(true)
        }
        
    }
}

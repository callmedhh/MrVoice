//
//  CustomerAnimatedTransitionController.swift
//  VoiceDiary
//
//  Created by dongyixuan on 16/6/26.
//  Copyright © 2016年 Lemur. All rights reserved.
//

import UIKit

class HistoryTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 1.2
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)

        let containerView = transitionContext.containerView()!
        toViewController.view.frame = finalFrame
        containerView.insertSubview(toViewController.view, atIndex: 0)


        if let fromVC = fromViewController as? MainViewController, let toVC = toViewController as? HistoryViewController {
            startTransition(from: fromVC, to: toVC, container: containerView, finish: {
                transitionContext.completeTransition(true)
            })
        }
        
        if let fromVC = fromViewController as? HistoryViewController, let toVC = toViewController as? MainViewController {
            startTransition(from: fromVC, to: toVC, container: containerView, finish: {
                transitionContext.completeTransition(true)
            })
        }
    }
    
    private func startTransition<VC1: UIViewController,  VC2: UIViewController where VC1: WithCalendarViewController, VC2: WithCalendarViewController>(from fromVC: VC1, to toVC: VC2, container containerView: UIView, finish: () -> ()) {
        
        toVC.getCalendarView().setNeedsLayout()
        toVC.getCalendarView().layoutIfNeeded()
        toVC.getCalendarView().hidden = true
        fromVC.getCalendarView().hidden = true
        toVC.view.setSubviewsAlpha(0, without: [1001])
        
        let originFrame =  fromVC.view.convertRect(fromVC.getCalendarView().frame, toView: containerView)
        let calendarView = CalendarView(frame: originFrame)
        calendarView.mode = fromVC.getCalendarView().mode
        calendarView.updateView()
        containerView.addSubview(calendarView)
        
        // vc.view
        UIView.animateWithDuration(duration/2, animations: {
            fromVC.view.alpha = 0
            }, completion: { finished in
                UIView.animateWithDuration(self.duration/2, animations: {
                    toVC.view.setSubviewsAlpha(1, without: [1001])
                    }, completion: { finished in
                        fromVC.view.alpha = 1
                        finish()
                })
        })
        
        // calendarView
        calendarView.mode = toVC.getCalendarView().mode
        UIView.animateWithDuration(duration, animations: {
            calendarView.frame = toVC.getCalendarView().frame
            calendarView.updateView()
            calendarView.updateLayer(self.duration, fromWidth: originFrame.size.width, toWidth: toVC.getCalendarView().frame.size.width)
            }, completion: { finished in
                calendarView.removeFromSuperview()
                toVC.getCalendarView().hidden = false
                fromVC.getCalendarView().hidden = false
        })
    }
}

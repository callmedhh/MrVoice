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
            fromViewController.view.backgroundColor = UIColor.clearColor()
            
            toVC.calenderView.progress = 1
            toVC.calenderView.setNeedsLayout()
            toVC.calenderView.layoutIfNeeded()
            toVC.calenderView.hidden = true
            
            for v in toVC.view.subviews {
                if v is CalenderView {
                    continue
                } else {
                    v.alpha = 0
                }
            }
            
            let duration = transitionDuration(transitionContext)
            
            // VC.view
            UIView.animateWithDuration(duration/2, animations: {
                for v in fromViewController.view.subviews {
                    if v is CalenderView {
                        continue
                    } else {
                        v.alpha = 0
                    }
                }
            }, completion: { finished in
                UIView.animateWithDuration(duration/2, animations: {
                    for v in toVC.view.subviews {
                        if v is CalenderView {
                            continue
                        } else {
                            v.alpha = 1
                        }
                    }
                }, completion: { finished in
                    for v in fromVC.view.subviews {
                        if v is CalenderView {
                            continue
                        } else {
                            v.alpha = 1
                        }
                    }
                    fromViewController.view.backgroundColor = originFromVCBackgroundColor
                })
            })

            // calendarView
            UIView.animateWithDuration(duration, animations: {
                fromVC.calenderView.frame = toVC.calenderView.frame
                fromVC.calenderView.progress = 1
                fromVC.calenderView.updateView()
                fromVC.calenderView.updateLayer(duration)
            }, completion: { finished in
                fromVC.calenderView.frame = originFrame
                fromVC.calenderView.progress = 0
                fromVC.calenderView.updateView()
                toVC.calenderView.hidden = false
                transitionContext.completeTransition(true)
            })
            
        } else if fromViewController is HistoryViewController && toViewController is MainViewController {
            let fromVC = fromViewController as! HistoryViewController
            let toVC = toViewController as! MainViewController
            
            toVC.calenderView.progress = 0
            toVC.calenderView.setNeedsLayout()
            toVC.calenderView.layoutIfNeeded()
            
            toVC.calenderView.hidden = true
            
            for v in toVC.view.subviews {
                if v is CalenderView {
                    continue
                } else {
                    v.alpha = 0
                }
            }
            let originFromVCBackgroundColor = fromVC.view.backgroundColor
            fromVC.view.backgroundColor = UIColor.clearColor()
    
            let duration = transitionDuration(transitionContext)
            //view
            UIView.animateWithDuration(duration/2, animations: {
                    for v in fromVC.view.subviews{
                        if v is CalenderView{
                            continue
                        }else {
                            v.alpha = 0
                        }
                    }
                },completion: { finished in
                    UIView.animateWithDuration(duration/2, animations: {
                        for v in toVC.view.subviews {
                            if v is CalenderView {
                                continue
                            }else {
                                v.alpha = 1
                            }
                        }
                    },completion:{ finished in
                        for v in fromVC.view.subviews{
                            if v is CalenderView{
                                continue
                            }else {
                                v.alpha = 1
                            }
                        }
                    })
            })
            // calendarView
            UIView.animateWithDuration(duration, animations: {
                fromVC.calenderView.progress = 0
                fromVC.calenderView.frame = toVC.calenderView.frame
                fromVC.calenderView.updateView()
                
                fromVC.calenderView.updateLayer(duration)
                }, completion: { finished in
                    toVC.calenderView.hidden = false
                    fromVC.calenderView.progress = 1
                    fromVC.view.backgroundColor = originFromVCBackgroundColor
                    transitionContext.completeTransition(true)
            })
        }
        
        

        
    }
}

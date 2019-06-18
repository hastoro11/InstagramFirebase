//
//  CameraControllerTransition.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 18..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

class CameraControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var duration = 0.5
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else {return}
        guard let fromView = transitionContext.view(forKey: .from) else {return}
        
        containerView.addSubview(toView)
        if presenting {
            toView.frame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        } else {
            toView.frame = CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            if self.presenting {
                toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
                fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            } else {
                toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
                fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            }
        }) { (_) in
            transitionContext.completeTransition(true)
        }
        
    }
}

//
//  ImageZoomTransitioning.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 22/02/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import UIKit

class ImageZoomTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    var duration: TimeInterval = 5.4
    fileprivate var image: UIImage?
    fileprivate var fromDelegate: ImageTransitionProtocol?
    fileprivate var toDelegate: ImageTransitionProtocol?
    
    // MARK: Setup Methods
    
    func setupImageTransition(image: UIImage, fromDelegate: ImageTransitionProtocol, toDelegate: ImageTransitionProtocol) {
        self.image = image
        self.fromDelegate = fromDelegate
        self.toDelegate = toDelegate
    }
    
    /// MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        
        let isUnwiding: Bool = toVC.presentedViewController == fromVC
        let isPresenting: Bool = !isUnwiding
        
        let presentingController = isPresenting ? fromVC : toVC
        let presentedController = isPresenting ? toVC : fromVC
        
        containerView.addSubview(presentingController.view)
        containerView.bringSubview(toFront: presentingController.view)
        
        // TODO: Protocol here
//        if let c = presentingController as? TimelineCollectionViewController {
//            c.transitionSetup()
//        }
        
        presentedController.view.alpha = 0
        if isPresenting {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
                presentedController.view.alpha = 1
                
            }, completion: { finished in
                
                presentingController.view.removeFromSuperview()
                // Complete transition
                if !transitionContext.transitionWasCancelled {
                    //                    containerView.addSubview(toVC.view)
                    
                    // The key UIWindow becomes completely empty – no view hierarchy at all!
                    // while dismissing a modal that is using presentation style OverCurrentContext or OverFullScreen
                    UIApplication.shared.keyWindow!.addSubview(toVC.view)
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
               
                presentedController.view.alpha = 0.4
            }, completion: { finished in
                // Complete transition
                presentingController.view.removeFromSuperview()

                if !transitionContext.transitionWasCancelled {
                    //                    containerView.addSubview(toVC.view)
                    
                    // The key UIWindow becomes completely empty – no view hierarchy at all!
                    // while dismissing a modal that is using presentation style OverCurrentContext or OverFullScreen
                    UIApplication.shared.keyWindow!.addSubview(toVC.view)
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
}

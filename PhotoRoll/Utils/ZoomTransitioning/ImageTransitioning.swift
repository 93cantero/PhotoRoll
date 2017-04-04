//
//  ZoomTransitioning.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 30/5/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

class ImageTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    var duration: TimeInterval = 0.4
    fileprivate var image: UIImage?
    fileprivate weak var fromDelegate: ImageTransitionProtocol?
    fileprivate weak var toDelegate: ImageTransitionProtocol?

    // MARK: Setup Methods

    func setupImageTransition(fromDelegate: ImageTransitionProtocol, toDelegate: ImageTransitionProtocol) {
        self.fromDelegate = fromDelegate
        self.toDelegate = toDelegate
    }
    
    func setImage(image: UIImage?) {
        self.image = image ?? self.image
    }

    /// MARK: UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    var containerView: UIView!
    var backgroundBlackView: UIView!
    var containerImageView: UIView!
    var imageView: UIImageView!
    var fromSnapshot: UIView!
    var toSnapshot: UIView!
    
    var fromVC: UIViewController!
    var toVC: UIViewController!
    
    func initializeViewControllers(using transitionContext: UIViewControllerContextTransitioning) {
        fromVC = transitionContext.viewController(forKey: .from)
        toVC = transitionContext.viewController(forKey: .to)
    }
    
    var isPresentingAnimation: Bool {
        return toVC.presentedViewController != fromVC
    }
    
    var isUnwindingAnimation: Bool {
        return toVC.presentedViewController == fromVC
    }
    
    func transitionSetUp() {
        fromDelegate!.transitionSetup(unwinding: isUnwindingAnimation)
        toDelegate!.transitionSetup(unwinding: isUnwindingAnimation)
    }
    
    func transitionCleanUp() {
        self.toDelegate!.transitionCleanup(unwinding: isUnwindingAnimation)
        self.fromDelegate!.transitionCleanup(unwinding: isUnwindingAnimation)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        beginTransition(using: transitionContext)
        setAlphaForBackgroundView()

        snapshotViewControllers()
        hideViewControllers()
        bringViewsToFront()
        
        animate(using: transitionContext)
    }
    
    func scaleFromVCToNinetyFivePercent() {
        self.fromVC.view.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1)
        self.fromSnapshot.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1)
    }
    
    func scaleViewControllersBackToItsInitialScale() {
        self.fromVC.view.layer.transform = CATransform3DIdentity
        self.toVC.view.layer.transform = CATransform3DIdentity
        self.fromSnapshot.layer.transform = CATransform3DIdentity
        self.toSnapshot.layer.transform = CATransform3DIdentity
    }
    
    func snapshotViewControllers() {
        /// This lets us manipulate its view in the animation without worrying about whether we are effecting the actual view.
        fromSnapshot = fromVC.view.snapshotView(afterScreenUpdates: true)!
        fromSnapshot.frame = fromVC.view.frame
        fromSnapshot.layer.transform = fromVC.view.layer.transform
        containerView.addSubview(fromSnapshot)
        
        toSnapshot = toVC.view.snapshotView(afterScreenUpdates: true)!
        toSnapshot.frame = fromVC.view.frame
        toSnapshot.layer.transform = toVC.view.layer.transform
        containerView.addSubview(toSnapshot)
        
    }
    
    func beginTransition(using transitionContext: UIViewControllerContextTransitioning) {
        initializeViewControllers(using: transitionContext)
        guard let _ = fromVC, let _ = toVC else { return }
        
        setUpContainer(using: transitionContext)
        transitionSetUp()
    }
    
    func setUpContainer(using context: UIViewControllerContextTransitioning) {
        containerView = context.containerView
        setUpViews()
    }
    
    func setUpViews() {
        setUpBackgroundView()
        setUpContainerImageView()
    }
    
    func setUpContainerImageView() {
        containerImageView = UIView()
        containerImageView.frame = getImageWindowFrame(fromDelegate: fromDelegate)
        containerImageView.backgroundColor = UIColor.black.withAlphaComponent(0)
        containerImageView.clipsToBounds = true
        setUpImageView()
        containerView.addSubview(containerImageView)
    }
    
    func setUpImageView() {
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = getImageWindowOffset(fromDelegate: fromDelegate)
        imageView.clipsToBounds = true
        imageView.alpha = 1
        containerImageView.addSubview(imageView)
    }
    
    func setUpBackgroundView() {
        backgroundBlackView = UIView(frame: UIApplication.shared.keyWindow!.frame)
        backgroundBlackView.backgroundColor = .black
        containerView.addSubview(backgroundBlackView)
    }
    
    func bringViewsToFront() {
        containerView.bringSubview(toFront: backgroundBlackView)
        containerView.bringSubview(toFront: containerImageView)
    }
    
    func setAlphaForBackgroundView() {
        let backgroundAlpha = isUnwindingAnimation ? fromVC.view.alpha : 0
        backgroundBlackView.alpha = backgroundAlpha
    }
    
    func hideViewControllers() {
        self.fromVC.view.isHidden = true
        self.toVC.view.isHidden = true
    }
    
    func showViewControllers() {
        self.fromVC.view.isHidden = false
        self.toVC.view.isHidden = false
    }
    
    func getImageWindowFrame(fromDelegate delegate: ImageTransitionProtocol?) -> CGRect {
        return (delegate == nil) ? CGRect.zero : delegate!.imageWindowFrame()
    }
    
    func getImageWindowOffset(fromDelegate delegate: ImageTransitionProtocol?) -> CGRect {
        var frame = getImageWindowFrame(fromDelegate: delegate)
        var origin: CGPoint = .zero
        if let offset = delegate?.imageOffset() {
            origin = CGPoint(x: offset.origin.x - frame.origin.x, y: offset.origin.y - frame.origin.y)
            frame.size = offset.size
        }
        return CGRect(origin: origin, size: frame.size)
    }
    
    func animate(using context: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.9, options: isUnwindingAnimation ? .curveEaseIn : .curveEaseOut,
                       animations: {
                        if self.isUnwindingAnimation {
                           self.scaleViewControllersBackToItsInitialScale()
                        } else {
                            self.scaleFromVCToNinetyFivePercent()
                        }
                        self.backgroundBlackView.alpha = self.isPresentingAnimation ? 0.95 : 0
                        self.containerImageView.frame = self.getImageWindowFrame(fromDelegate: self.toDelegate)
                        self.imageView.frame = self.getImageWindowOffset(fromDelegate: self.toDelegate)
        }, completion: { _ in
            self.completeTransition(using: context)
        })
    }
    
    func completeTransition(using context: UIViewControllerContextTransitioning) {
        showViewControllers()
        transitionCleanUp()
        
        removeViewsUsedForTransition()
        
        // Complete transition
        if !context.transitionWasCancelled {
            // The key UIWindow becomes completely empty – no view hierarchy at all!
            // while dismissing a modal that is using presentation style OverCurrentContext or OverFullScreen
            UIApplication.shared.keyWindow!.addSubview(self.toVC.view)
            releaseControllersInvolvedOnTransition()
        }
        context.completeTransition(!context.transitionWasCancelled)

    }
    
    func releaseControllersInvolvedOnTransition() {
        fromVC = nil
        toVC = nil
    }
    
    func removeViewsUsedForTransition() {
        backgroundBlackView.removeFromSuperview()
        containerImageView.removeFromSuperview()
        fromSnapshot.removeFromSuperview()
        toSnapshot.removeFromSuperview()
    }
}

protocol ImageTransitionProtocol: class {

    /// Will be called by the animation controller before the snapshots for the animation are taken.
    /// This enables the view controllers to make changes that will only appear in the animation.
    ///
    /// - Returns: ()
    func transitionSetup(unwinding: Bool)

    /// Will be called after the transition is complete.
    /// This lets view controllers undo any changes they may have made purely for the transition.
    ///
    func transitionCleanup(unwinding: Bool)

    /// Will return the frame of the selected image in window coordinates
    ///
    func imageWindowFrame() -> CGRect
    
    /// Return the offset of the image (if any)
    ///
    func imageOffset() -> CGRect?
}


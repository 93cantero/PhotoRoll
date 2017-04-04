//
//  ImageDetailViewController+UIScrollView.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 09/03/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import UIKit

extension ImageDetailViewController {
    
    // MARK: Gesture recognizer
    
    @IBAction func tapRecognized(_ sender: UITapGestureRecognizer) {
        currentZoomForScrollView = scrollView.zoomScale
        setTopAndBottomBarsHidden(hidden: self.controlsView.alpha != 0, animated: true)
    }
    
    @IBAction func doubleTapRecognized(_ sender: UITapGestureRecognizer) {
        if self.scrollView.zoomScale > self.scrollView.minimumZoomScale {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        } else {
            self.scrollView.zoom(to: self.zoomRect(forScale: self.scrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
        }
    }
    
    func zoomRect(forScale scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect(x: 0, y: 0, width: imageView.frame.width / scale, height: imageView.frame.height / scale)
        
        let c = imageView.convert(center, from: self.scrollView)
        let originX = c.x - (zoomRect.width / 2.0)
        let originY = c.y - (zoomRect.height)
        
        zoomRect.origin = CGPoint(x: originX, y: originY)
        
        return zoomRect
    }
    
    var lastTimePanGestureMoved: Double? {
        return benchMarkTimer?.stop()
    }
    
    var constrainedScreenHeight: CGFloat {
        let screenSize = UIScreen.main.bounds
        return screenSize.height - 40
    }
    
    @IBAction func panRecognized(_ sender: UIPanGestureRecognizer) {
        
        scrollView.bounces = false
        
        // Gesture Began
        if sender.state == .began {
            startMeasuringTimeToCalculateVelocity()
            setVariablesOnGestureBegin()
        }
        
        if (isVerticalGesture && scrollView.contentSize.height < constrainedScreenHeight) {
            scrollView.panGestureRecognizer.isEnabled = false
            positionComponentsForVerticalGesture()
            scrollView.panGestureRecognizer.isEnabled = true
        }
        
        scrollView.bounces = true
    }
    
    func startMeasuringTimeToCalculateVelocity() {
        if let timer = benchMarkTimer {
            timer.start()
        } else {
            benchMarkTimer = BenchmarkTimer()
        }
    }
    
    func returnView(to centerPoint: CGPoint) {
        self.view.backgroundColor = .black
        
        UIView.beginAnimations(nil, context: .none)
        UIView.setAnimationCurve(.easeOut)
        UIView.setAnimationDelegate(self)
        scrollView.center = centerPoint
        UIView.commitAnimations()
    }
    
    func repositionCenter() {
        let finalPoint = CGPoint(x: firstX, y: viewHalfHeight)
        returnView(to: finalPoint)
    }
    
    func setVariablesOnGestureBegin() {
        firstX = scrollView.center.x
        firstY = scrollView.center.y
        
        isVerticalGesture = panGesture.direction?.isVertical ?? false
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func positionComponentsForVerticalGesture() {
        moveViewOnVerticalGesture()
        if panGesture.state == .ended {
            endTranslation()
        } else if panGesture.state == .cancelled || panGesture.state == .failed {
            repositionCenter()
        }
    }
    
    func moveViewOnVerticalGesture() {
        let viewHeight = scrollView.frame.size.height
        viewHalfHeight = viewHeight/2
        
        var translatedPoint = panGesture.translation(in: self.view)
        
        let screenSize = UIScreen.main.bounds
        let x = scrollView.contentSize.width > screenSize.width ? firstX : firstX + translatedPoint.x
        let y = firstY + translatedPoint.y
        translatedPoint = CGPoint(x: x, y: y)
        
        UIView.animate(withDuration: 0.1) {
            self.scrollView.center = translatedPoint
            self.fadeView(using: translatedPoint)
        }
    }
    
    func fadeView(using translatedPoint: CGPoint) {
        let newY = translatedPoint.y - viewHalfHeight
        let finalHeight = viewHalfHeight - (viewHalfHeight/2)
        let newAlpha = 1 - fabsf(Float(newY/finalHeight))
        
        //        self.topBarTopConstraint.constant = -abs(newY/2.5)
        //        self.toolBarBottomConstraint.constant = -abs(newY/2.5)
//        setTopAndBottomBarsHidden(hidden: -abs(newY/2.5) < 0, animated: false, translatedY: newY)
//        let translatedY = -abs(newY/2.5)
//        translatedY < 0 ? setTopAndBottomBarHidden(translatedY: translatedY) : setTopAndBottomBarVisible(translatedY: translatedY)
        
        self.view.isOpaque = false
        backgroundAlpha = CGFloat(newAlpha)
    }
    
    var translationNeededToDismissTheView: CGFloat {
        return 100
    }
    
    var isScrollViewCenterYHigherThanTranslationNeeded: Bool {
        return scrollView.center.y > viewHalfHeight + translationNeededToDismissTheView
    }
    
    var isScrollViewCenterYLowerThanTranslationNeeded: Bool {
        return scrollView.center.y < viewHalfHeight - translationNeededToDismissTheView
    }
    
    var translationMovementMoreThanSixtyPixels: Bool {
        return scrollView.center.y < viewHalfHeight - 60 || scrollView.center.y > viewHalfHeight + 60
    }
    
    var shouldEndTranslation: Bool {
        return ((isScrollViewCenterYHigherThanTranslationNeeded || isScrollViewCenterYLowerThanTranslationNeeded) && scrollView.contentOffset.y == 0) || isVelocityHigherThanMinimumNeeded()
    }
    
    var timeVelocityOfPanGesture: Double {
        return benchMarkTimer!.stop()
    }
    
    func isVelocityHigherThanMinimumNeeded() -> Bool {
        let time = timeVelocityOfPanGesture
        print("Time Velocity: \(time)")
        return time < 0.06 && translationMovementMoreThanSixtyPixels
    }
    
    func endTranslation() {
        if shouldEndTranslation {
            scrollView.panGestureRecognizer.isEnabled = false
            imageFrame = imageView.superview!.convert(imageView.frame, to: .none)
            fadeOutComponents()
            self.perform(#selector(backButtonSelected), with: self, afterDelay: 0)
        } else {
            repositionCenter()
        }
    }
    
    func fadeOutComponents() {
        scrollView.isHidden = true
        if let imgFrame = imageFrame {
            placeholderImageView = UIImageView(image: self.imageView.image)
            placeholderImageView!.contentMode = .scaleAspectFill
            placeholderImageView!.frame = imgFrame
            placeholderImageView!.clipsToBounds = true
            placeholderImageView!.alpha = 1
            self.view.addSubview(placeholderImageView!)
        }
        
        self.setTopAndBottomBarsHidden(hidden: true, animated: true)
    }
    
    func setTopAndBottomBarsHidden(hidden isHidden: Bool, animated isAnimated: Bool, translatedY: CGFloat?) {
        if isAnimated{
            isHidden ? setTopAndBottomBarHidden(translatedY: translatedY) : setTopAndBottomBarVisible(translatedY: translatedY)
            UIView.animate(withDuration: 0.2) {
                self.setTopAndBottomBarsAlpha(isHidden ? 0 : self.topAndBottomViewsAlpha)
                self.view.layoutIfNeeded()
            }
        } else {
            isHidden ? self.setTopAndBottomBarHidden(translatedY: translatedY) : self.setTopAndBottomBarVisible(translatedY: translatedY)
        }
    }
    
    func getPercentage(percentage: CGFloat, forHeight height: CGFloat) -> CGFloat {
        return height != 0 ? percentage * 100 / height : 0
    }
    
    func getBottomBarMovementPercentage(usingTranslationY translationY: CGFloat) -> CGFloat {
        return getPercentage(percentage: translationY, forHeight: self.controlsView.frame.height)
    }
    
    func getTopBarMovementPercentage(usingTranslationY translationY: CGFloat) -> CGFloat {
        return getPercentage(percentage: translationY, forHeight: self.detailsView.frame.height)
    }
    
    func setTopAndBottomBarsHidden(hidden isHidden: Bool, animated isAnimated: Bool) {
        setTopAndBottomBarsHidden(hidden: isHidden, animated: isAnimated, translatedY: .none)
    }
    
    func setTopAndBottomBarHidden(translatedY: CGFloat? = .none) {
        if let y = translatedY {
            self.setTopBarHidden(hidden: true, percentage: getTopBarMovementPercentage(usingTranslationY: y))
            self.setBottomBarHidden(hidden: true, percentage: getBottomBarMovementPercentage(usingTranslationY: y))
        } else {
            self.setTopBarHidden(hidden: true)
            self.setBottomBarHidden(hidden: true)
        }
    }
    
    func setTopAndBottomBarVisible(translatedY: CGFloat? = .none) {
        if let y = translatedY {
            self.setTopBarHidden(hidden: false, percentage: getTopBarMovementPercentage(usingTranslationY: y))
            self.setBottomBarHidden(hidden: false, percentage: getBottomBarMovementPercentage(usingTranslationY: y))
        } else {
            self.setTopBarHidden(hidden: false)
            self.setBottomBarHidden(hidden: false)
        }
    }
    
    func setTopBarHidden(hidden isHidden: Bool, percentage: CGFloat = 100) {
        let pixelsToMove = self.controlsView.frame.height - (self.controlsView.frame.height / 100 * percentage)
        self.topBarTopConstraint.constant = isHidden ? -self.controlsView.frame.height : pixelsToMove
    }
    
    func setBottomBarHidden(hidden isHidden: Bool, percentage: CGFloat = 100) {
        let pixelsToMove = abs(self.detailsView.frame.height / 100 * percentage)
        self.bottomBarBottomConstraint.constant = isHidden ? -pixelsToMove : self.detailsView.frame.height - pixelsToMove
    }
    
    func setTopAndBottomBarsAlpha(_ alpha: CGFloat) {
        self.controlsView.alpha = alpha
        self.detailsView.alpha = alpha
    }
}

extension ImageDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints(forSize: view.bounds.size)
    }
}


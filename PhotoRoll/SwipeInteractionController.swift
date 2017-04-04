//
//  SwipeInterationController.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 11/10/2016.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {

    var interactionInProgress = false

    fileprivate var shouldCompleteTransition = false
    fileprivate weak var viewController: UIViewController!

    func wireTo(viewController: UIViewController!) {
        self.viewController = viewController
        prepareGestureRecognizerInView(view: viewController.view)
    }

    // MARK: Gesture recognizer

    fileprivate func prepareGestureRecognizerInView(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        panGesture.minimumNumberOfTouches = 1
        view.addGestureRecognizer(panGesture)
    }

    func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {

        // A Swipe of 200 points will lead to 100% completion
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.y / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

        switch gestureRecognizer.state {

        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: .none)

        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)

        case .cancelled:
            interactionInProgress = false
            cancel()

        case .ended:
            interactionInProgress = false

            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }

        default:
            print("Unsupported")
        }
    }

}

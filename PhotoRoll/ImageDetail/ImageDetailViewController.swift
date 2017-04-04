//
//  ImageDetailViewController.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit
import TTTAttributedLabel

protocol ImageDetailViewControllerInput {
    func presentImage(_ img: UIImage)
}

protocol ImageDetailViewControllerOutput {
    func fetchImage(_ id: Photos.FetchImage.Request)
    func cancelFetchImage()
}

class ImageDetailViewController: UIViewController, ImageDetailViewControllerInput, TTTAttributedLabelDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var labelScroll: UIScrollView!
    
    /// Constraints
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    // TOP and Bottom Bar Constraints
    @IBOutlet weak var bottomScrollViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topScrollViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingScrollViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingScrollViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBarBottomConstraint: NSLayoutConstraint!
    
    /// Gestures
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet var doubleTapGesture: UITapGestureRecognizer!
    
    
    //Labels
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: TTTAttributedLabel!
    @IBOutlet weak var labelCreatedAt: UILabel!
    
    var output: ImageDetailViewControllerOutput!
    var router: ImageDetailRouter!
    var image: UIImage!
    var photo: Photos.DisplayedMedia?
    var photos: [Photos.DisplayedMedia]?
    let topAndBottomViewsAlpha: CGFloat = 0.65
    var backgroundAlpha : CGFloat = 1 {
        willSet {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(newValue)
        }
    }
    var currentZoomForScrollView: CGFloat?
    
    // MARK: Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageDetailConfigurator.sharedInstance.configure(self)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.view.alpha = 1
        
        setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statusBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
        setGestureFailureRequirements()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    deinit {
        print("Deinit ImageDetailViewController")
        output.cancelFetchImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScale(forSize: view.bounds.size)
        
        if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
    }
    
    func setUpViews() {
        if let photo = photo {
            fetchImageOnLoad(displayedMedia: photo)
            setDetailLabelProperties()
            setTitles(forPhoto: photo)
        }
    }
    
    func fetchImageOnLoad(displayedMedia photo: Photos.DisplayedMedia) {
        self.imageView.image = image
        output.fetchImage(Photos.FetchImage.Request(imageUrl: photo.highQualityImageUrl ?? photo.imageUrl))
    }
    
    func setTitles(forPhoto photo: Photos.DisplayedMedia) {
        labelTitle.text = photo.name
        labelDetail.setText(photo.desc.htmlToString)
        labelCreatedAt.text = photo.createdAt
    }
    
    func setDetailLabelProperties() {
        let t = labelDetail.text
        let url = NSURL(string: "http://more.com")!
        let truncatedStringColour = [
            kCTForegroundColorAttributeName as String: UIColor(red: 142.0/255.0, green: 59.0/255.0, blue: 84.0/255.0, alpha: 1.0),
            NSLinkAttributeName : url
        ] as [String : Any]
        
        labelDetail.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        labelDetail.delegate = self
//        labelDetail.numberOfLines = 2
//        labelDetail.allowsDefaultTighteningForTruncation = true
//        labelDetail.attributedTruncationToken = NSAttributedString(string: "...Show more", attributes: truncatedStringColour)
//        labelDetail.text = t
        
        styleLinksForLabelDetail()
    }
    
    func styleLinksForLabelDetail() {
        let linkAttributes = NSMutableDictionary(dictionary: labelDetail.linkAttributes)
        linkAttributes[NSForegroundColorAttributeName] = UIColor.white
        linkAttributes[NSFontAttributeName] = UIFont.boldSystemFont(ofSize: labelDetail.font.pointSize)
        labelDetail.linkAttributes = linkAttributes as NSDictionary as! [AnyHashable: Any]
        
        let activeLinkAttributes = NSMutableDictionary(dictionary: labelDetail.activeLinkAttributes)
        activeLinkAttributes[NSForegroundColorAttributeName] = UIColor(hex: "#BDBDBD")
        labelDetail.activeLinkAttributes = activeLinkAttributes as NSDictionary as! [AnyHashable: Any]
    }
    
    func expandText() {
        setLabelDetailNumberOf(lines: 0)
    }
    
    func collapseText() {
        setLabelDetailNumberOf(lines: 3)
    }
    
    func setLabelDetailNumberOf(lines: Int) {
        labelDetail.numberOfLines = lines
        detailsView.layoutIfNeeded()
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print("Click on \(url)")
    }
    
    // MARK: Status Bar
    var statusBarHidden: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Styling Methods
    
    fileprivate func addShadowToView(_ view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }
    
    // MARK: ImageDetailViewControllerInput
    
    func presentImage(_ img: UIImage) {
        view.isUserInteractionEnabled = false
        view.layoutIfNeeded()
        let frame = visibleFrame()
        let scaleDifference = scrollView.zoomScale / scrollView.minimumZoomScale
        UIView.animate(withDuration: 0.0, animations: {
            self.imageView.image = img
            self.view.isUserInteractionEnabled = true
            //This will trigger the update of min and max zoom scale
            self.view.layoutIfNeeded()
            self.updateMinZoomScale(forSize: self.view.bounds.size)
        }, completion: {_ in
            let newScaleBasedOnZoomedScaleForPreviousImage = scaleDifference * self.scrollView.minimumZoomScale
            self.scrollView.setZoomScale(newScaleBasedOnZoomedScaleForPreviousImage, animated: false)
            let proportionalSize = self.proportionalSizeForNewImage(usingZoomRect: frame)
            self.scrollView.setContentOffset(proportionalSize.origin, animated: false)
        })
        
    }
    
    func visibleFrame() -> CGRect {
        var visibleRect = CGRect.zero
        visibleRect.origin = scrollView.contentOffset
        visibleRect.size = scrollView.bounds.size
        
        let zoom = scrollView.zoomScale
        visibleRect.origin.x = visibleRect.origin.x / zoom
        visibleRect.origin.y = visibleRect.origin.y / zoom
        visibleRect.size.width = visibleRect.size.width / zoom
        visibleRect.size.height = visibleRect.size.height / zoom
        return visibleRect
    }
    
    func proportionalSizeForNewImage(usingZoomRect zoom: CGRect) -> CGRect {
        var zoomRect = CGRect.zero
        
        zoomRect.origin.x = zoom.origin.x * scrollView.zoomScale
        zoomRect.origin.y = zoom.origin.y * scrollView.zoomScale
        zoomRect.size.width = zoom.size.width * scrollView.zoomScale
        zoomRect.size.height = zoom.size.height * scrollView.zoomScale
        
        return zoomRect
    }
    
    // MARK: Display logic
    
    func updateMinZoomScale(forSize size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 2.5
        
        scrollView.zoomScale = currentZoomForScrollView ?? minScale
        currentZoomForScrollView = .none
    }
    
    func updateConstraints(forSize size: CGSize) {
        
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        scrollView.layoutIfNeeded()
    }
    
    @IBAction func backButtonSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Extract this to a class
    @IBAction func shareButtonPressed() {
        let actionSheet = UIAlertController(title: "", message: "Share", preferredStyle: .actionSheet)
        let actionSaveOnPhotosAlbum = UIAlertAction(title: "Save to Photos Album", style: .default) { _ in
            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(self.didSave(image:withError:contextInfo:)), nil)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: .none)
        actionSheet.addAction(actionSaveOnPhotosAlbum)
        actionSheet.addAction(actionCancel)
        //        actionCancel.
        
        present(actionSheet, animated: true, completion: .none)
    }
    
    func didSave(image: UIImage, withError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Image saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }

    // MARK: ScrollView and Zooming variables used for animations
    var firstX: CGFloat = 0
    var firstY: CGFloat = 0
    var isVerticalGesture: Bool = false
    var benchMarkTimer: BenchmarkTimer?
    var imageFrame: CGRect?
    var viewHalfHeight: CGFloat = 0
    var placeholderImageView: UIImageView?    
}

extension ImageDetailViewController : UIGestureRecognizerDelegate {
    
    func setGestureFailureRequirements() {
//        if let pinch = scrollView.pinchGestureRecognizer {
//            panGesture.require(toFail: pinch)
//        }
        tapGesture.require(toFail: doubleTapGesture)
    }
    
    //Allow the scrollView to scroll
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == panGesture && (otherGestureRecognizer == scrollView.pinchGestureRecognizer) {
            return false
        }
        return true
    }
    
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        switch (gestureRecognizer, gestureRecognizer.state) {
//        case (let g, let s) where g == panGesture && (s == .possible || s == .failed):
//            return false
//        default:
//            return true
//        }
//    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer == scrollView.pinchGestureRecognizer && otherGestureRecognizer == panGesture {
//            return true
//        }
//        else if gestureRecognizer == panGesture, otherGestureRecognizer == scrollView.panGestureRecognizer && (imageView.frame.height < scrollView.bounds.height - 50) {
//            return true
//        }
        
        // At this point is not possible to measure velocity to know if the gesture is vertical
        
//        return false
//    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer == panGesture || (otherGestureRecognizer == scrollView.panGestureRecognizer && scrollView.zoomScale > scrollView.maximumZoomScale - 0.2) {
//            return false
//        }
//        return true
//    }

}

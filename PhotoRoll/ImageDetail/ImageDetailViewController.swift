//
//  ImageDetailViewController.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 19/5/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 1.5
    }
}

//
//  ImageDetailViewController.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit

protocol ImageDetailViewControllerInput {
}

protocol ImageDetailViewControllerOutput {
    func fetchImage(id: Photos.FetchImage.Request)
}

class ImageDetailViewController: UIViewController, ImageDetailViewControllerInput
{
    @IBOutlet var scrollView : UIScrollView!
    
    var output: ImageDetailViewControllerOutput!
    var router: ImageDetailRouter!
    
    // MARK: Object lifecycle
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        ImageDetailConfigurator.sharedInstance.configure(self)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        output.fetchImage(Photos.FetchImage.Request(id: 2))
    }
    
    // MARK: Event handling
    
    
    // MARK: Display logic
    
}

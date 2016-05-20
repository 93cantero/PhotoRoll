//
//  PhotosTimelineViewController.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//

import UIKit

protocol PhotosTimelineViewControllerInput {
    func displayMedia(viewModel: Photos.FetchMedia.ViewModel)
}

protocol PhotosTimelineViewControllerOutput {
    func fetchMedia(request: Photos.FetchMedia.Request)
}

class PhotosTimelineViewController: UITableViewController, PhotosTimelineViewControllerInput
{
  var output: PhotosTimelineViewControllerOutput!
  var router: PhotosTimelineRouter!
  
    var displayedMedia : [Photos.DisplayedMedia] = []
    
  // MARK: Object lifecycle
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
//    PhotosTimelineConfigurator.sharedInstance.configure(self)
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    output.fetchMedia(Photos.FetchMedia.Request())
  }
    
    //MARK: TableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("photoCell")
        
        if (cell == nil) {
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "photoCell")
            cell = UITableViewCell(style:.Default, reuseIdentifier: "photoCell")
        }
        
        cell?.textLabel?.text = displayedMedia[indexPath.row].name
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedMedia.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: Methods
    
    
  
  // MARK: Event handling

  
  // MARK: Display logic

    func displayMedia(viewModel: Photos.FetchMedia.ViewModel) {
        displayedMedia = viewModel.displayedMedia
        tableView.reloadData()
    }
}

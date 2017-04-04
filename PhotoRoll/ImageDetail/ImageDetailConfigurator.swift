//
//  ImageDetailConfigurator.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 20/5/16.
//  Copyright (c) 2016 Francisco Jose . All rights reserved.
//
//

import UIKit

// MARK: Connect View, Interactor, and Presenter

extension ImageDetailViewController: ImageDetailPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue)
    }
}

extension ImageDetailInteractor: ImageDetailViewControllerOutput {
}

extension ImageDetailPresenter: ImageDetailInteractorOutput {
}

class ImageDetailConfigurator {
    
    // MARK: Object lifecycle
    
    static let sharedInstance: ImageDetailConfigurator = {
        let instance = ImageDetailConfigurator()
        return instance
    }()
    
    // MARK: Configuration
    
    func configure(_ viewController: ImageDetailViewController) {
        let router = ImageDetailRouter()
        router.viewController = viewController
        
        let presenter = ImageDetailPresenter()
        presenter.output = viewController
        
        let interactor = ImageDetailInteractor()
        interactor.output = presenter
        
        viewController.output = interactor
        viewController.router = router
    }
}

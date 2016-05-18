//
//  ClientFiveHundredPxPhotos.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 17/3/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import Foundation

class ClientPhotos : BaseClientAPI {
    
    private func fetch(target: TargetAPI, completion: (success: Bool, object: AnyObject?) -> ()) {
        get(target, params: target.parameters) { (success, obj) -> () in
            completion(success: success, object: obj)
        }
    }
    
    //    func fetch(target: FiveHundredPx, completion: (success: Bool, object: AnyObject?) -> ()) {
    //        fetch(target) { (success, obj) -> () in
    //            
    //        }
    //    }
}
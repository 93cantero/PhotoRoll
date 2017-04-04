//
//  ClientFiveHundredPxPhotos.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 17/3/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import Foundation

class ClientPhotos: BaseClientAPI {

    fileprivate func fetch(_ target: TargetAPI, completion: @escaping (_ success: Bool, _ object: Any?) -> Void) {
        get(target, params: target.parameters) { (success, obj) -> Void in
            completion(success, obj)
        }
    }

    //    func fetch(target: FiveHundredPx, completion: (success: Bool, object: AnyObject?) -> ()) {
    //        fetch(target) { (success, obj) -> () in
    //            
    //        }
    //    }
}

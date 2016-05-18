//
//  StringExtensions.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import Foundation

extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
    
    var UTF8EncodedData: NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}

extension Dictionary {
    mutating func append(other:Dictionary) {
        self.forEach { self.updateValue($1, forKey: $0)}
    }
}


extension CollectionType {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
//
//  StringExtensions.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 16/3/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import Foundation
import UIKit

extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }

    var utf8EncodedData: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data,
                                          options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return .none
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension Dictionary {
    mutating func append(_ other: Dictionary) {
        self.forEach { self.updateValue($1, forKey: $0)}
    }
}

extension Collection {
    public subscript(safe safeIndex: Index) -> _Element? {
        return safeIndex < self.endIndex ? self[safeIndex] : nil
//        return safeIndex.distanceTo(endIndex) > 0 ?  : nil
    }
}

//extension Collection {
//    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
//    subscript (safe index: Index) -> Iterator.Element? {
//        ///TODO: CHECK THIS
//        return indices.contains(where: index as! (_) throws -> Bool) ? self[index] : nil
//    }
//}

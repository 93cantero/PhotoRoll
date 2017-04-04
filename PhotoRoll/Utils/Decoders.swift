//
//  StructDecoder.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 29/3/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import Foundation
import CoreData

enum SerializationError: Error {
    //Protocol is not conformed on a struct type
    case structRequired
    //The entity does not exist in the CoreData model
    case unknownEntity(name: String)
    //The provided type cannot be stored in CoreData (for instance enum, etc)
    case unsupportedSubType(label: String)
}

protocol StructDecoder {
    //Returns a NSManagedObject with the properties properly set
    func toCoreData(_ context: NSManagedObjectContext) throws -> NSManagedObject

    /* Parse a dictionary to a Media struct
     * - param The parameters are in a dictionary. This dictionary takes the parameters not common with the struct properties. If all parameters are the same, you can omit this value
     *
     */
//    static func parseWithDictionary(notCommonKeys: [String:String]?, json: [String: AnyObject]) -> Self
}

extension StructDecoder {

    func toCoreData(_ context: NSManagedObjectContext) throws -> NSManagedObject {
        //Get the entityName
        let entityName = String(describing: type(of: self))

        //Mirror the struct
        let mirror = Mirror(reflecting: self)
        guard mirror.displayStyle == .struct else { throw SerializationError.structRequired }

        //Creck for knowing entity
        guard let entityDesc = NSEntityDescription.entity(forEntityName: entityName, in: context) else { throw SerializationError.unknownEntity(name: entityName) }
        //Create the managedObject
        let object = NSManagedObject(entity: entityDesc, insertInto: context)

        for case let (label?, value) in mirror.children {
//            if let v = value as? AnyObject {
                object.setValue(value, forKey: label)
//            } else {
//                throw SerializationError.unsupportedSubType(label: label)
//            }
        }

        return object
    }
}

// MARK: JSON PARSER

protocol JSONParselable {
    static func decode(_ json: [String:AnyObject]) -> Self?
}

//extension JSONParselable {
//    static func decode(json: [String:AnyObject]) -> Self? {
//        
//    }
//}

//Operators have to be declared at global scope
infix operator >>>=
/** Takes an optional type and a function that takes A as a parameter and returns an optional B.
 *
 */
func >>>= <A, B> (optional: A?, f: (A) -> B?) -> B? {
    return flatten(optional.map(f))
}

/** Removes one level of optional-ness
 */
func flatten<A>(_ x: A??) -> A? {
    if let y = x { return y }
    return nil
}

func number(_ input: [AnyHashable: Any], key: String) -> NSNumber? {
    return input[key] >>>= { $0 as? NSNumber }
}

func int(_ input: [AnyHashable: Any], key: String) -> Int? {
    return number(input, key: key).map { $0.intValue }
}

func float(_ input: [AnyHashable: Any], key: String) -> Float? {
    return number(input, key: key).map { $0.floatValue }
}

func double(_ input: [AnyHashable: Any], key: String) -> Double? {
    return number(input, key: key).map { $0.doubleValue }
}

func string(_ input: [String:AnyObject], key: String) -> String? {
    return input[key] >>>= { $0 as? String }
}

func bool(_ input: [String:AnyObject], key: String) -> Bool? {
    return number(input, key: key).map { $0.boolValue }
}

//struct JSONParser <T: StructDecoder> {
//}
//
//extension JSONParser {
//    static func parse(data: NSData) throws -> [T] {
//        do {
//            let jsonSerialization = try NSJSONSerialization.JSONObjectWithData(data, options: [])
//            
//            let mirror = Mirror(reflecting: jsonSerialization as! [String:AnyObject])
//            
//            for case let (label?, value) in mirror.children {
//                
//                if label == T.path {
//                    //Get the data
////                    T.parseWithDictionary(["desc": "description"], json: <#T##[String : AnyObject]#>)
//                }
//                do {
//                    print(value)
//                } catch {
//                    
//                }
//            }
//            
//            return []
//        } catch _ {
//            //            throw SerializationError.StructRequired
//            return []
//        }
//    }
//
//}

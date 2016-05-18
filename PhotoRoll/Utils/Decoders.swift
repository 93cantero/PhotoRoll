//
//  StructDecoder.swift
//  PhotoRoll
//
//  Created by Francisco Jose  on 29/3/16.
//  Copyright © 2016 Francisco Jose . All rights reserved.
//

import Foundation
import CoreData

enum SerializationError : ErrorType {
    //Protocol is not conformed on a struct type
    case StructRequired
    //The entity does not exist in the CoreData model
    case UnknownEntity(name: String)
    //The provided type cannot be stored in CoreData (for instance enum, etc)
    case UnsupportedSubType(label: String)
}

protocol StructDecoder {
    //Returns a NSManagedObject with the properties properly set
    func toCoreData(context: NSManagedObjectContext) throws -> NSManagedObject
    
    /* Parse a dictionary to a Media struct
     * - param The parameters are in a dictionary. This dictionary takes the parameters not common with the struct properties. If all parameters are the same, you can omit this value
     *
     */
//    static func parseWithDictionary(notCommonKeys: [String:String]?, json: [String: AnyObject]) -> Self
}

extension StructDecoder {
    
    func toCoreData(context: NSManagedObjectContext) throws -> NSManagedObject {
        //Get the entityName
        let entityName = String(self.dynamicType)
        
        //Mirror the struct
        let mirror = Mirror(reflecting: self)
        guard mirror.displayStyle == .Struct else { throw SerializationError.StructRequired }
        
        //Creck for knowing entity
        guard let entityDesc = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context) else { throw SerializationError.UnknownEntity(name: entityName) }
        //Create the managedObject
        let object = NSManagedObject(entity: entityDesc, insertIntoManagedObjectContext: context)
        
        for case let (label?, value) in mirror.children {
            if let v = value as? AnyObject {
                object.setValue(v, forKey: label)
            } else {
                throw SerializationError.UnsupportedSubType(label: label)
            }
        }
        
        return object
    }
}


//MARK: JSON PARSER

protocol JSONParselable {
    static func decode(json: [String:AnyObject]) -> Self?
}

//extension JSONParselable {
//    static func decode(json: [String:AnyObject]) -> Self? {
//        
//    }
//}

//Operators have to be declared at global scope
infix operator >>>= {}
/** Takes an optional type and a function that takes A as a parameter and returns an optional B.
 *
 */
func >>>= <A, B> (optional: A?, f: A -> B?) -> B? {
    return flatten(optional.map(f))
}

/** Removes one level of optional-ness
 */
func flatten<A>(x: A??) -> A? {
    if let y = x { return y }
    return nil
}

func number(input: [NSObject:AnyObject], key: String) -> NSNumber? {
    return input[key] >>>= { $0 as? NSNumber }
}

func int(input: [NSObject:AnyObject], key: String) -> Int? {
    return number(input, key: key).map { $0.integerValue }
}

func float(input: [NSObject:AnyObject], key: String) -> Float? {
    return number(input, key: key).map { $0.floatValue }
}

func double(input: [NSObject:AnyObject], key: String) -> Double? {
    return number(input, key: key).map { $0.doubleValue }
}

func string(input: [String:AnyObject], key: String) -> String? {
    return input[key] >>>= { $0 as? String }
}

func bool(input: [String:AnyObject], key: String) -> Bool? {
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
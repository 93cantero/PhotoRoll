//
//  File.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 06/04/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import Foundation

//
///  Given a value to round and a factor to round to,
///  round the value to the nearest multiple of that factor.
///
/// - Parameters:
///   - value: Value we want to round
///   - toNearest: toNearest description
/// - Returns: return value description
func round(_ value: Double, toNearest: Double) -> Decimal {
    return Decimal((value * toNearest).rounded() / toNearest)
}

// Given a value to round and a factor to round to,
// round the value DOWN to the largest previous multiple
// of that factor.
func roundDown(_ value: Double, toNearest: Double) -> Decimal {
    return Decimal((value * toNearest).rounded(.down) / toNearest)
}

// Given a value to round and a factor to round to,
// round the value DOWN to the largest previous multiple
// of that factor.
func roundUp(_ value: Double, toNearest: Double) -> Double {
    return (value * toNearest).rounded(.up) / toNearest
}
